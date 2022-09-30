package test

import (
	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"testing"
)

// TestExamplesComplete tests a typical deployment of this module
func TestExamplesComplete(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../../examples/complete",
		EnvVars:      map[string]string{},
		Vars:         map[string]interface{}{},
	}
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApplyAndIdempotent(t, terraformOptions)

	passwordSsmName := terraform.Output(t, terraformOptions, "password_ssm_name")
	region := terraform.Output(t, terraformOptions, "region")
	password := terraform.Output(t, terraformOptions, "password")

	logger.Log(t, "Creating AWS Session")
	awsSess := GetAWSSession()

	logger.Log(t, "Validating the password is set correctly in SSM")
	ssmParam := GetSSMParameter(awsSess, region, passwordSsmName)
	assert.Equal(t, password, *ssmParam.Value)

	logger.Log(t, "Validating the password is encrypted")
	assert.Equal(t, "SecureString", *ssmParam.Type)
}
