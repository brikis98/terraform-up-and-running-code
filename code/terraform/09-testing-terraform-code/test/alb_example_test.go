package test

import (
	"fmt"
	"github.com/stretchr/testify/require"

	"github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"testing"
	"time"
)

func TestAlbExample(t *testing.T) {

	t.Parallel()

	opts := &terraform.Options{
		// You should update this relative path to point at your alb
		// example directory!
		TerraformDir: "../examples/alb",

		Vars: map[string]interface{}{
			"alb_name": fmt.Sprintf("test-%s", random.UniqueId()),
		},

	}

	// Clean up everything at the end of the test
	defer terraform.Destroy(t, opts)

	// Deploy the example
	terraform.InitAndApply(t, opts)

	// Get the URL of the ALB
	albDnsName := terraform.OutputRequired(t, opts, "alb_dns_name")
	url := fmt.Sprintf("http://%s", albDnsName)

	// Test that the ALB's default action is working and returns a 404
	expectedStatus := 404
	expectedBody := "404: page not found"
	maxRetries := 10
	timeBetweenRetries := 10 * time.Second

	http_helper.HttpGetWithRetry(
		t,
		url,
		nil,
		expectedStatus,
		expectedBody,
		maxRetries,
		timeBetweenRetries,
	)

}

func TestAlbExamplePlan(t *testing.T) {
	t.Parallel()

	albName := fmt.Sprintf("test-%s", random.UniqueId())

	opts := &terraform.Options{
		// You should update this relative path to point at your alb
		// example directory!
		TerraformDir: "../examples/alb",
		Vars: map[string]interface{}{
			"alb_name": albName,
		},
	}

	planString := terraform.InitAndPlan(t, opts)

	// An example of how to check the plan output's add/change/destroy counts
	resourceCounts := terraform.GetResourceCount(t, planString)
	require.Equal(t, 5, resourceCounts.Add)
	require.Equal(t, 0, resourceCounts.Change)
	require.Equal(t, 0, resourceCounts.Destroy)

	// An example of how to check specific values in the plan output
	planStruct :=
		terraform.InitAndPlanAndShowWithStructNoLogTempPlanFile(t, opts)

	alb, exists :=
		planStruct.ResourcePlannedValuesMap["module.alb.aws_lb.example"]
	require.True(t, exists, "aws_lb resource must exist")

	name, exists := alb.AttributeValues["name"]
	require.True(t, exists, "missing name parameter")
	require.Equal(t, albName, name)
}

