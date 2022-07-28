package test

import (
	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"os"
	"testing"
	"time"
)

// TestExamplesComplete tests a typical deployment of this module
func TestExamplesComplete(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../../examples/complete",
		EnvVars:      map[string]string{},
	}
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApplyAndIdempotent(t, terraformOptions)

	passwordSsmName := terraform.Output(t, terraformOptions, "password_ssm_name")
	region := terraform.Output(t, terraformOptions, "region")
	password := terraform.Output(t, terraformOptions, "password")
	cloudwatchLogGroup := terraform.Output(t, terraformOptions, "lambda_cloudwatch_log_group")

	logger.Log(t, "Creating AWS Session")
	awsSess := GetAWSSession()

	logger.Log(t, "Validating the password is set correctly in SSM")
	ssmParam := GetSSMParameter(awsSess, region, passwordSsmName)
	assert.Equal(t, password, *ssmParam.Value)

	logger.Log(t, "Validating the password is encrypted")
	assert.Equal(t, "SecureString", *ssmParam.Type)

	logger.Log(t, "Waiting for IAM Auth Lambda to run")
	time.Sleep(60 * time.Second)

	actualLogStreamName := GetLogStream(awsSess, region, cloudwatchLogGroup)
	logger.Log(t, "Getting logs for IAM Auth Lambda")
	outputLogs := GetLogs(awsSess, region, cloudwatchLogGroup, actualLogStreamName)

	logger.Log(t, "Checking logs for connection status for IAM Auth Lambda")
	assert.Contains(t, *outputLogs[1].Message, "SUCCESS")

	logger.Log(t, "Checking logs for IAM Auth Lambda that read only database user was created")
	expectedQueryResponse := "('%', 'db_iam_admin')"
	assert.Contains(t, *outputLogs[2].Message, expectedQueryResponse)
}
