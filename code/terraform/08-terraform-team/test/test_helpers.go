package test

import (
	"os"
	"testing"
)

// To avoid wasting lots of time constantly creating and deleting S3 buckets for the tests that need to store state in
// an S3 backend, some of the tests require that you create the S3 bucket ahead of time and set the bucket name and
// region as environment variables. Note that these env vars are also read automatically by terragrunt.hcl files.
const TerraformStateBucketForTestEnvVarName = "TEST_STATE_S3_BUCKET"
const TerraformStateRegionForTestEnvVarName = "TEST_STATE_REGION"

// Get the value of the environment variable with the given name. If that environment variable is not set, fail the
// test.
func GetRequiredEnvVar(t *testing.T, envVarName string) string {
	envVarValue := os.Getenv(envVarName)
	if envVarValue == "" {
		t.Fatalf("Required environment variable '%s' is not set", envVarName)
	}
	return envVarValue
}