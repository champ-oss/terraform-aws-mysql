package test

import (
	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"os"
	"testing"
	"time"
)

// TestExamplesComplete tests a typical deployment of this module. It will verify the SSM parameter is set correctly
// and that snapshots are all working as expected.
func TestExamplesComplete(t *testing.T) {
	t.Parallel()

	name := "complete"

	terraformOptions := &terraform.Options{
		TerraformDir: "../../examples/complete",
		EnvVars: map[string]string{
			"TF_WORKSPACE": name,
			"TF_DATA_DIR":  name,
		},
		Vars: map[string]interface{}{
			"iam_auth_docker_tag": os.Getenv("GITHUB_SHA"),
		},
	}
	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	passwordSsmName := terraform.Output(t, terraformOptions, "password_ssm_name")
	region := terraform.Output(t, terraformOptions, "region")
	password := terraform.Output(t, terraformOptions, "password")
	identifier := terraform.Output(t, terraformOptions, "identifier")
	finalSnapshotIdentifier := terraform.Output(t, terraformOptions, "final_snapshot_identifier")
	resourceId := terraform.Output(t, terraformOptions, "resource_id")
	// get lambda tf output logGroupName
	cloudwatchLogGroup := terraform.Output(t, terraformOptions, "lambda_cloudwatch_log_group")

	// Calling Sleep method to test lambda function
	time.Sleep(60 * time.Second)

	logger.Log(t, "Creating AWS Session")
	awsSess := GetAWSSession()

	actualLogStreamName := GetLogStream(awsSess, region, cloudwatchLogGroup)
	logger.Log(t, "getting logs from lambda")
	outputLogs := GetLogs(awsSess, region, cloudwatchLogGroup, actualLogStreamName)

	logger.Log(t, "Scheduling snapshots to be deleted")
	defer DeleteDBBackup(awsSess, region, resourceId)
	defer DeleteDBSnapshot(awsSess, region, finalSnapshotIdentifier)

	logger.Log(t, "Running terraform plan to check for idempotency")
	exitCode := terraform.PlanExitCode(t, terraformOptions)
	assert.Equal(t, 0, exitCode)

	logger.Log(t, "Validating the password is set correctly in SSM")
	ssmParam := GetSSMParameter(awsSess, region, passwordSsmName)
	assert.Equal(t, password, *ssmParam.Value)

	logger.Log(t, "Validating the password is encrypted")
	assert.Equal(t, "SecureString", *ssmParam.Type)

	logger.Log(t, "Explicitly destroying the RDS so we can check the final snapshot")
	terraform.Destroy(t, terraformOptions)

	logger.Log(t, "Validating there is one automated/system snapshot (created when RDS is first created)")
	automatedSnapshots := GetDBSnapshots(awsSess, region, identifier, "automated")
	assert.Len(t, automatedSnapshots, 1)

	logger.Log(t, "Validating there is one manual final snapshot (created when RDS is destroyed)")
	manualSnapshots := GetDBSnapshots(awsSess, region, identifier, "manual")
	assert.Len(t, manualSnapshots, 1)

	logger.Log(t, "checking lambda connection status")
	expectedConnectionResponse := "SUCCESS"
	assert.Contains(t, *outputLogs[1].Message, expectedConnectionResponse)

	logger.Log(t, "query output from RDS that read only database user was created")
	expectedQueryResponse := "('%', 'db_iam_admin')"
	assert.Contains(t, *outputLogs[2].Message, expectedQueryResponse)
}
