package test

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"os/exec"
	"testing"
)

// TestChangeSnapshot tests a typical use-case by and end user where they change the snapshot identifier of an existing
// RDS instance to restore it to a point-in-time. In doing so, no conflicts should exist with naming the instance
// and final snapshots.
//
// Basic workflow:
// 1: User updates the "snapshot_identifier" of an existing RDS
// 2: The RDS should create a final snapshot and then the RDS will be recreated with a new identifier.
// 3: Later once everything is destroyed, two final snapshots should be retained.
func TestChangeSnapshot(t *testing.T) {
	t.Parallel()

	name := "change_snapshot"

	terraformOptions := &terraform.Options{
		TerraformDir: "../../examples/complete",
		EnvVars: map[string]string{
			"TF_WORKSPACE": name,
			"TF_DATA_DIR":  name,
		},
		Vars: map[string]interface{}{
			"snapshot_identifier": "",
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.Init(t, terraformOptions)

	// recursively set prevent destroy to false
	cmd := exec.Command("bash", "-c", "find . -type f -name '*.tf' -exec sed -i'' -e 's/prevent_destroy = true/prevent_destroy = false/g' {} +")
	cmd.Dir = "../../"
	_ = cmd.Run()

	terraform.ApplyAndIdempotent(t, terraformOptions)

	region := terraform.Output(t, terraformOptions, "region")
	identifier := terraform.Output(t, terraformOptions, "identifier")
	originalResourceId := terraform.Output(t, terraformOptions, "resource_id")
	originalFinalSnapshotIdentifier := terraform.Output(t, terraformOptions, "final_snapshot_identifier")
	snapshotName := fmt.Sprintf("%s-manual", identifier)

	logger.Log(t, "Scheduling snapshots to be deleted")
	awsSess := GetAWSSession()
	defer DeleteDBBackup(awsSess, region, originalResourceId)
	defer DeleteDBSnapshot(awsSess, region, originalFinalSnapshotIdentifier)

	logger.Log(t, "Taking a manual snapshot of the RDS that we can use to restore from")
	WaitUntilDBInstanceAvailable(awsSess, region, identifier)
	CreateDBSnapshot(awsSess, region, identifier, snapshotName)
	defer DeleteDBSnapshot(awsSess, region, snapshotName)

	logger.Log(t, "Updating RDS to use new manual snapshot which will cause a rebuild")
	WaitUntilDBInstanceAvailable(awsSess, region, identifier)
	WaitUntilDBSnapshotAvailable(awsSess, region, snapshotName)
	terraformOptions.Vars["snapshot_identifier"] = snapshotName
	terraform.Apply(t, terraformOptions)
	newResourceId := terraform.Output(t, terraformOptions, "resource_id")
	newFinalSnapshotIdentifier := terraform.Output(t, terraformOptions, "final_snapshot_identifier")

	logger.Log(t, "Running terraform plan to check for idempotency")
	exitCode := terraform.PlanExitCode(t, terraformOptions)
	assert.Equal(t, 0, exitCode)

	logger.Log(t, "Explicitly destroying the RDS so we can check the final snapshots")
	WaitUntilDBInstanceAvailable(awsSess, region, identifier)
	terraform.Destroy(t, terraformOptions)

	logger.Log(t, "Scheduling snapshots to be deleted")
	defer DeleteDBBackup(awsSess, region, newResourceId)
	defer DeleteDBSnapshot(awsSess, region, newFinalSnapshotIdentifier)

	logger.Log(t, "Validating there are 2 automated/system snapshots (created when RDS is recreated each time)")
	automatedSnapshotsNew := GetDBSnapshots(awsSess, region, identifier, "automated")
	assert.Len(t, automatedSnapshotsNew, 2)

	logger.Log(t, "Validating there are 3 manual snapshots (2 when RDS destroyed and 1 we created)")
	manualSnapshotsNew := GetDBSnapshots(awsSess, region, identifier, "manual")
	assert.Len(t, manualSnapshotsNew, 3)
}
