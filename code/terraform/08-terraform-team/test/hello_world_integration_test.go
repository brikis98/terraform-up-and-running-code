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

func TestHelloWorldAppStageWithStages(t *testing.T)  {
	t.Parallel()

	dbModuleDir := "../live/stage/data-stores/mysql"

	defer test_structure.RunTestStage(t, "teardown_db", func() {
		dbOpts := test_structure.LoadTerraformOptions(t, dbModuleDir)
		defer terraform.Destroy(t, dbOpts)
	})

	test_structure.RunTestStage(t, "deploy_db", func() {
		uniqueId := random.UniqueId()

		dbOpts := &terraform.Options{
			TerraformDir: dbModuleDir,

			// These modules use Terragrunt as a wrapper for Terraform
			TerraformBinary: "terragrunt",

			Vars: map[string]interface{}{
				"db_name": fmt.Sprintf("test_%s", uniqueId),
				"db_password": "password",
			},

			// terragrunt.hcl looks up its settings using env vars
			EnvVars: map[string]string{
				"TEST_STATE_DYNAMODB_TABLE": uniqueId,
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

		helloOpts := &terraform.Options{
			TerraformDir: helloWorldAppDir,

			// These modules use Terragrunt as a wrapper for Terraform
			TerraformBinary: "terragrunt",

			Vars: map[string]interface{}{
				"environment": fmt.Sprintf("test-%s", uniqueId),
			},

			// terragrunt.hcl looks up its settings using env vars
			EnvVars: map[string]string{
				"TEST_STATE_DYNAMODB_TABLE": uniqueId,
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

	dbModuleDir := "../live/prod/data-stores/mysql"

	defer test_structure.RunTestStage(t, "teardown_db", func() {
		dbOpts := test_structure.LoadTerraformOptions(t, dbModuleDir)
		defer terraform.Destroy(t, dbOpts)
	})

	test_structure.RunTestStage(t, "deploy_db", func() {
		uniqueId := random.UniqueId()

		dbOpts := &terraform.Options{
			TerraformDir: dbModuleDir,

			// These modules use Terragrunt as a wrapper for Terraform
			TerraformBinary: "terragrunt",

			Vars: map[string]interface{}{
				"db_name": fmt.Sprintf("test_%s", uniqueId),
				"db_password": "password",
			},

			// terragrunt.hcl looks up its settings using env vars
			EnvVars: map[string]string{
				"TEST_STATE_DYNAMODB_TABLE": uniqueId,
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

		helloOpts := &terraform.Options{
			TerraformDir: helloWorldAppDir,

			// These modules use Terragrunt as a wrapper for Terraform
			TerraformBinary: "terragrunt",

			Vars: map[string]interface{}{
				"environment": fmt.Sprintf("test-%s", uniqueId),
			},

			// terragrunt.hcl looks up its settings using env vars
			EnvVars: map[string]string{
				"TEST_STATE_DYNAMODB_TABLE": uniqueId,
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
