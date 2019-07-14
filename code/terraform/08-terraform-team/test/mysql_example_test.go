package test

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"testing"
)

func TestMySqlExample(t *testing.T)  {
	t.Parallel()

	terraformOptions := &terraform.Options{
		// You should update this relative path to point at your mysql
		// example directory!
		TerraformDir: "../examples/mysql",
		Vars: map[string]interface{}{
			"db_name": fmt.Sprintf("test_%s", random.UniqueId()),
			"db_password": "password",
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
