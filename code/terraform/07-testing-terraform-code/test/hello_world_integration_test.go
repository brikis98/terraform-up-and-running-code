package test

import (
	"fmt"
	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/gruntwork-io/terratest/modules/test-structure"
	"strings"
	"testing"
	"time"
)

func TestHelloWorldAppStage(t *testing.T)  {
	t.Parallel()

	uniqueId := random.UniqueId()

	bucketForTesting := GetRequiredEnvVar(t, TerraformStateBucketForTestEnvVarName)
	bucketRegionForTesting := GetRequiredEnvVar(t, TerraformStateRegionForTestEnvVarName)

	dbStateKey := fmt.Sprintf("%s/%s/terraform.tfstate", t.Name(), uniqueId)

	dbOpts := &terraform.Options{
		TerraformDir: "../live/stage/data-stores/mysql",

		Vars: map[string]interface{}{
			"db_name": fmt.Sprintf("test_%s", uniqueId),
			"db_password": "password",
		},

		BackendConfig: map[string]interface{}{
			"bucket":         bucketForTesting,
			"region":         bucketRegionForTesting,
			"key":            dbStateKey,
			"encrypt":        true,
		},
	}

	defer terraform.Destroy(t, dbOpts)
	terraform.InitAndApply(t, dbOpts)

	helloOpts := &terraform.Options{
		TerraformDir: "../live/stage/services/hello-world-app",

		Vars: map[string]interface{}{
			"db_remote_state_bucket": bucketForTesting,
			"db_remote_state_key": dbStateKey,
			"environment": fmt.Sprintf("test-%s", uniqueId),
		},
	}

	defer terraform.Destroy(t, helloOpts)
	terraform.InitAndApply(t, helloOpts)

	albDnsName := terraform.OutputRequired(t, helloOpts, "alb_dns_name")
	url := fmt.Sprintf("http://%s", albDnsName)

	maxRetries := 10
	timeBetweenRetries := 10 * time.Second

	http_helper.HttpGetWithRetryWithCustomValidation(
		t,
		url,
		maxRetries,
		timeBetweenRetries,
		func(status int, body string) bool {
			return status == 200 && strings.Contains(body, "Hello, World")
		},
	)

}

func TestHelloWorldAppStageWithStages(t *testing.T)  {
	t.Parallel()

	bucketForTesting := GetRequiredEnvVar(t, TerraformStateBucketForTestEnvVarName)
	bucketRegionForTesting := GetRequiredEnvVar(t, TerraformStateRegionForTestEnvVarName)

	dbModuleDir := "../live/stage/data-stores/mysql"

	defer test_structure.RunTestStage(t, "teardown_db", func() {
		dbOpts := test_structure.LoadTerraformOptions(t, dbModuleDir)
		defer terraform.Destroy(t, dbOpts)
	})

	test_structure.RunTestStage(t, "deploy_db", func() {
		uniqueId := random.UniqueId()
		dbStateKey := fmt.Sprintf(
			"%s/%s/terraform.tfstate",
			t.Name(),
			uniqueId,
		)

		dbOpts := &terraform.Options{
			TerraformDir: dbModuleDir,

			Vars: map[string]interface{}{
				"db_name": fmt.Sprintf("test_%s", uniqueId),
				"db_password": "password",
			},

			BackendConfig: map[string]interface{}{
				"bucket":         bucketForTesting,
				"region":         bucketRegionForTesting,
				"key":            dbStateKey,
				"encrypt":        true,
			},
		}

		// Save data to disk so that other test stages executed at a later
		// time can read the data back in
		test_structure.SaveTerraformOptions(t, dbModuleDir, dbOpts)
		test_structure.SaveString(t, dbModuleDir, "uniqueId", uniqueId)

		terraform.InitAndApply(t, dbOpts)
	})

	helloWorldAppDir := "../live/stage/services/hello-world-app"

	defer test_structure.RunTestStage(t, "teardown_hello_world_app", func() {
		helloOpts := test_structure.LoadTerraformOptions(t, helloWorldAppDir)
		defer terraform.Destroy(t, helloOpts)
	})

	test_structure.RunTestStage(t, "deploy_hello_world_app", func() {
		uniqueId := test_structure.LoadString(t, dbModuleDir, "uniqueId")
		dbOpts := test_structure.LoadTerraformOptions(t, dbModuleDir)

		helloOpts := &terraform.Options{
			TerraformDir: helloWorldAppDir,

			Vars: map[string]interface{}{
				"db_remote_state_bucket": bucketForTesting,
				"db_remote_state_key": dbOpts.BackendConfig["key"],
				"environment": fmt.Sprintf("test-%s", uniqueId),
			},

			// Retry up to 3 times, with 5 seconds between retries,
			// on known errors
			MaxRetries: 3,
			TimeBetweenRetries: 5 * time.Second,
			RetryableTerraformErrors: map[string]string{
				"RequestError: send request failed": "Throttling issue?",
			},
		}

		test_structure.SaveTerraformOptions(t, helloWorldAppDir, helloOpts)

		terraform.InitAndApply(t, helloOpts)
	})

	test_structure.RunTestStage(t, "validate_hello_world_app", func() {
		helloOpts := test_structure.LoadTerraformOptions(t, helloWorldAppDir)

		albDnsName := terraform.OutputRequired(t, helloOpts, "alb_dns_name")
		url := fmt.Sprintf("http://%s", albDnsName)

		maxRetries := 10
		timeBetweenRetries := 10 * time.Second

		http_helper.HttpGetWithRetryWithCustomValidation(
			t,
			url,
			maxRetries,
			timeBetweenRetries,
			func(status int, body string) bool {
				return status == 200 && strings.Contains(body, "Hello, World")
			},
		)
	})

	test_structure.RunTestStage(t, "redeploy_hello_world_app", func() {
		helloOpts := test_structure.LoadTerraformOptions(t, helloWorldAppDir)

		albDnsName := terraform.OutputRequired(t, helloOpts, "alb_dns_name")
		url := fmt.Sprintf("http://%s", albDnsName)

		// Start checking every 1s that the app is responding with a 200 OK
		stopChecking := make(chan bool, 1)
		waitGroup, _ := http_helper.ContinuouslyCheckUrl(
			t,
			url,
			stopChecking,
			1*time.Second,
		)

		// Update the server text and redeploy
		newServerText := "Hello, World, v2!"
		helloOpts.Vars["server_text"] = newServerText
		terraform.Apply(t, helloOpts)

		// Make sure the new version deployed
		maxRetries := 10
		timeBetweenRetries := 10 * time.Second
		http_helper.HttpGetWithRetryWithCustomValidation(
			t,
			url,
			maxRetries,
			timeBetweenRetries,
			func(status int, body string) bool {
				return status == 200 && strings.Contains(body, newServerText)
			},
		)

		// Stop checking
		stopChecking <- true
		waitGroup.Wait()
	})

}

func TestHelloWorldAppProdWithStages(t *testing.T)  {
	t.Parallel()

	bucketForTesting := GetRequiredEnvVar(t, TerraformStateBucketForTestEnvVarName)
	bucketRegionForTesting := GetRequiredEnvVar(t, TerraformStateRegionForTestEnvVarName)

	dbModuleDir := "../live/prod/data-stores/mysql"

	defer test_structure.RunTestStage(t, "teardown_db", func() {
		dbOpts := test_structure.LoadTerraformOptions(t, dbModuleDir)
		defer terraform.Destroy(t, dbOpts)
	})

	test_structure.RunTestStage(t, "deploy_db", func() {
		uniqueId := random.UniqueId()
		dbStateKey := fmt.Sprintf("%s/%s/terraform.tfstate", t.Name(), uniqueId)

		dbOpts := &terraform.Options{
			TerraformDir: dbModuleDir,

			Vars: map[string]interface{}{
				"db_name": fmt.Sprintf("test_%s", uniqueId),
				"db_password": "password",
			},

			BackendConfig: map[string]interface{}{
				"bucket":         bucketForTesting,
				"region":         bucketRegionForTesting,
				"key":            dbStateKey,
				"encrypt":        true,
			},
		}

		test_structure.SaveTerraformOptions(t, dbModuleDir, dbOpts)
		test_structure.SaveString(t, dbModuleDir, "uniqueId", uniqueId)

		terraform.InitAndApply(t, dbOpts)
	})

	helloWorldAppDir := "../live/prod/services/hello-world-app"

	defer test_structure.RunTestStage(t, "teardown_hello_world_app", func() {
		helloOpts := test_structure.LoadTerraformOptions(t, helloWorldAppDir)
		defer terraform.Destroy(t, helloOpts)
	})

	test_structure.RunTestStage(t, "deploy_hello_world_app", func() {
		uniqueId := test_structure.LoadString(t, dbModuleDir, "uniqueId")
		dbOpts := test_structure.LoadTerraformOptions(t, dbModuleDir)

		helloOpts := &terraform.Options{
			TerraformDir: helloWorldAppDir,

			Vars: map[string]interface{}{
				"db_remote_state_bucket": bucketForTesting,
				"db_remote_state_key": dbOpts.BackendConfig["key"],
				"environment": fmt.Sprintf("test-%s", uniqueId),
			},

			// Retry up to 3 times, with 5 seconds between retries, on known errors
			MaxRetries: 3,
			TimeBetweenRetries: 5 * time.Second,
			RetryableTerraformErrors: map[string]string{
				"RequestError: send request failed": "Intermittent error, possibly due to throttling?",
			},
		}

		test_structure.SaveTerraformOptions(t, helloWorldAppDir, helloOpts)

		terraform.InitAndApply(t, helloOpts)
	})

	test_structure.RunTestStage(t, "validate_hello_world_app", func() {
		helloOpts := test_structure.LoadTerraformOptions(t, helloWorldAppDir)

		albDnsName := terraform.OutputRequired(t, helloOpts, "alb_dns_name")
		url := fmt.Sprintf("http://%s", albDnsName)

		maxRetries := 10
		timeBetweenRetries := 10 * time.Second

		http_helper.HttpGetWithRetryWithCustomValidation(t, url, maxRetries, timeBetweenRetries, func(status int, body string) bool {
			return status == 200 && strings.Contains(body, "Hello, World")
		})
	})

	test_structure.RunTestStage(t, "redeploy_hello_world_app", func() {
		helloOpts := test_structure.LoadTerraformOptions(t, helloWorldAppDir)

		albDnsName := terraform.OutputRequired(t, helloOpts, "alb_dns_name")
		url := fmt.Sprintf("http://%s", albDnsName)

		// Start checking every 1s that the app is responding with a 200 OK
		stopChecking := make(chan bool, 1)
		waitGroup, _ := http_helper.ContinuouslyCheckUrl(t, url, stopChecking, 1*time.Second)

		// Update the server text and redeploy
		newServerText := "Hello, World, v2!"
		helloOpts.Vars["server_text"] = newServerText
		terraform.Apply(t, helloOpts)

		// Make sure the new version deployed
		maxRetries := 10
		timeBetweenRetries := 10 * time.Second
		http_helper.HttpGetWithRetryWithCustomValidation(t, url, maxRetries, timeBetweenRetries, func(status int, body string) bool {
			return status == 200 && strings.Contains(body, newServerText)
		})

		// Stop checking
		stopChecking <- true
		waitGroup.Wait()
	})
}
