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

// Replace these with the proper paths to your modules
const dbDirProd = "../live/prod/data-stores/mysql"
const appDirProd = "../live/prod/services/hello-world-app"
const dbDirStage = "../live/stage/data-stores/mysql"
const appDirStage = "../live/stage/services/hello-world-app"

func TestHelloWorldAppStageWithStages(t *testing.T) {
	t.Parallel()

	// Deploy the MySQL DB
	defer test_structure.RunTestStage(t, "teardown_db", func() { teardownDb(t, dbDirStage) })
	test_structure.RunTestStage(t, "deploy_db", func() { deployDb(t, dbDirStage) })

	// Deploy the hello-world-app
	defer test_structure.RunTestStage(t, "teardown_app", func() { teardownHelloApp(t, appDirStage) })
	test_structure.RunTestStage(t, "deploy_app", func() { deployHelloApp(t, dbDirStage, appDirStage) })

	// Validate the hello-world-app works
	test_structure.RunTestStage(t, "validate_app", func() { validateHelloApp(t, appDirStage) })

	// Redeploy the hello-world-app
	test_structure.RunTestStage(t, "redeploy_app", func() { redeployHelloApp(t, appDirStage) })
}

func TestHelloWorldAppProdWithStages(t *testing.T)  {
	t.Parallel()

	// Deploy the MySQL DB
	defer test_structure.RunTestStage(t, "teardown_db", func() { teardownDb(t, dbDirProd) })
	test_structure.RunTestStage(t, "deploy_db", func() { deployDb(t, dbDirProd) })

	// Deploy the hello-world-app
	defer test_structure.RunTestStage(t, "teardown_app", func() { teardownHelloApp(t, appDirProd) })
	test_structure.RunTestStage(t, "deploy_app", func() { deployHelloApp(t, dbDirProd, appDirProd) })

	// Validate the hello-world-app works
	test_structure.RunTestStage(t, "validate_app", func() { validateHelloApp(t, appDirProd) })

	// Redeploy the hello-world-app
	test_structure.RunTestStage(t, "redeploy_app", func() { redeployHelloApp(t, appDirProd) })
}

func createDbOpts(terraformDir string, uniqueId string) *terraform.Options {
	return &terraform.Options{
		TerraformDir: terraformDir,

		// These modules use Terragrunt as a wrapper for Terraform
		TerraformBinary: "terragrunt",

		Vars: map[string]interface{}{
			"db_name": fmt.Sprintf("test%s", uniqueId),
			"db_password": "password",
		},

		// terragrunt.hcl looks up its settings using env vars
		EnvVars: map[string]string{
			"TEST_STATE_DYNAMODB_TABLE": uniqueId,
		},
	}
}

func createHelloOpts(terraformDir string, uniqueId string) *terraform.Options {
	return &terraform.Options{
		TerraformDir: terraformDir,

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
}

func validateApp(t *testing.T, helloOpts *terraform.Options) {
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

func teardownDb(t *testing.T, dbDir string) {
	dbOpts := test_structure.LoadTerraformOptions(t, dbDir)
	defer terraform.Destroy(t, dbOpts)
}

func deployDb(t *testing.T, dbDir string) {
	uniqueId := random.UniqueId()
	dbOpts := createDbOpts(dbDir, uniqueId)

	// Save data to disk so that other test stages executed at a later
	// time can read the data back in
	test_structure.SaveTerraformOptions(t, dbDir, dbOpts)
	test_structure.SaveString(t, dbDir, "uniqueId", uniqueId)

	terraform.InitAndApply(t, dbOpts)
}

func teardownHelloApp(t *testing.T, helloAppDir string) {
	helloOpts := test_structure.LoadTerraformOptions(t, helloAppDir)
	defer terraform.Destroy(t, helloOpts)
}

func deployHelloApp(t *testing.T, dbDir string, helloAppDir string) {
	uniqueId := test_structure.LoadString(t, dbDir, "uniqueId")
	helloOpts := createHelloOpts(helloAppDir, uniqueId)

	// Save data to disk so that other test stages executed at a later
	// time can read the data back in
	test_structure.SaveTerraformOptions(t, helloAppDir, helloOpts)

	terraform.InitAndApply(t, helloOpts)
}

func validateHelloApp(t *testing.T, helloAppDir string)  {
	helloOpts := test_structure.LoadTerraformOptions(t, helloAppDir)
	validateApp(t, helloOpts)
}

func redeployHelloApp(t *testing.T, helloAppDir string) {
	helloOpts := test_structure.LoadTerraformOptions(t, helloAppDir)

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
}
