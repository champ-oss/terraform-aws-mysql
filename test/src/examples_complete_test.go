package test

import (
	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"os"
	"os/exec"
	"testing"
	"time"
)

// TestExamplesComplete tests a typical deployment of this module. It will verify the SSM parameter is set correctly
// and that snapshots are all working as expected.
func TestExamplesComplete(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../../examples/complete",
		EnvVars:      map[string]string{},
		Vars: map[string]interface{}{
			"iam_auth_docker_tag": os.Getenv("GITHUB_SHA"),
		},
	}
	defer terraform.Destroy(t, terraformOptions)

	terraform.Init(t, terraformOptions)

	// recursively set prevent destroy to false
	cmd := exec.Command("bash", "-c", "find . -type f -name '*.tf' -exec sed -i'' -e 's/prevent_destroy = true/prevent_destroy = false/g' {} +")
	cmd.Dir = "../../"
	_ = cmd.Run()

	terraform.ApplyAndIdempotent(t, terraformOptions)

	passwordSsmName := terraform.Output(t, terraformOptions, "password_ssm_name")
	region := terraform.Output(t, terraformOptions, "region")
	password := terraform.Output(t, terraformOptions, "password")
	identifier := terraform.Output(t, terraformOptions, "identifier")
	finalSnapshotIdentifier := terraform.Output(t, terraformOptions, "final_snapshot_identifier")
	resourceId := terraform.Output(t, terraformOptions, "resource_id")
	cloudwatchLogGroup := terraform.Output(t, terraformOptions, "lambda_cloudwatch_log_group")

	logger.Log(t, "Creating AWS Session")
	awsSess := GetAWSSession()

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
