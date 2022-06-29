package test

import (
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/cloudwatchlogs"
	"github.com/aws/aws-sdk-go/service/rds"
	"github.com/aws/aws-sdk-go/service/ssm"
)

// GetAWSSession Logs in to AWS and return a session
func GetAWSSession() *session.Session {
	fmt.Println("Getting AWS Session")
	sess, err := session.NewSessionWithOptions(session.Options{
		SharedConfigState: session.SharedConfigEnable,
	})
	if err != nil {
		panic(err)
	}
	return sess
}

// GetSSMParameter fetches and returns an SSM parameter with fields such as Value and Type
func GetSSMParameter(session *session.Session, region string, name string) *ssm.Parameter {
	fmt.Println("Getting SSM parameter:", name)
	svc := ssm.New(session, aws.NewConfig().WithRegion(region))
	res, err := svc.GetParameter(&ssm.GetParameterInput{
		Name:           aws.String(name),
		WithDecryption: aws.Bool(true),
	})
	if err != nil {
		panic(err)
	}
	return res.Parameter
}

// GetDBSnapshots returns a list of DB snapshots belonging to a specific RDS DB instance
func GetDBSnapshots(session *session.Session, region string, dBInstanceIdentifier string, snapshotType string) []*rds.DBSnapshot {
	fmt.Println("Getting DB Snapshots:", dBInstanceIdentifier)
	svc := rds.New(session, aws.NewConfig().WithRegion(region))
	res, err := svc.DescribeDBSnapshots(&rds.DescribeDBSnapshotsInput{
		DBInstanceIdentifier: aws.String(dBInstanceIdentifier),
		SnapshotType:         aws.String(snapshotType),
	})
	if err != nil {
		panic(err)
	}
	return res.DBSnapshots
}

// DeleteDBSnapshot deletes a specific snapshot given a snapshot ID. It will wait to make sure the snapshot is
// available before trying to delete it.
func DeleteDBSnapshot(session *session.Session, region string, dBSnapshotIdentifier string) {
	svc := rds.New(session, aws.NewConfig().WithRegion(region))

	fmt.Println("Waiting for DB snapshot to become available:", dBSnapshotIdentifier)
	err := svc.WaitUntilDBSnapshotAvailable(&rds.DescribeDBSnapshotsInput{
		DBSnapshotIdentifier: aws.String(dBSnapshotIdentifier),
	})
	if err != nil {
		panic(err)
	}

	fmt.Println("Deleting DB Snapshot:", dBSnapshotIdentifier)
	_, err = svc.DeleteDBSnapshot(&rds.DeleteDBSnapshotInput{
		DBSnapshotIdentifier: aws.String(dBSnapshotIdentifier),
	})
	if err != nil {
		panic(err)
	}
	fmt.Println("Successfully deleted DB Snapshot:", dBSnapshotIdentifier)
}

// DeleteDBBackup deletes a specific RDS backup given the DB resource ID
func DeleteDBBackup(session *session.Session, region string, dbiResourceId string) {
	fmt.Println("Deleting DB Backup:", dbiResourceId)
	svc := rds.New(session, aws.NewConfig().WithRegion(region))
	_, err := svc.DeleteDBInstanceAutomatedBackup(&rds.DeleteDBInstanceAutomatedBackupInput{
		DbiResourceId: aws.String(dbiResourceId),
	})
	if err != nil {
		panic(err)
	}
	fmt.Println("Successfully deleted DB Backup:", dbiResourceId)
}

func GetLogs(session *session.Session, region string, logGroup string, logStream *string) []*cloudwatchlogs.OutputLogEvent {
	svc := cloudwatchlogs.New(session, aws.NewConfig().WithRegion(region))

	params := &cloudwatchlogs.GetLogEventsInput{
		LogGroupName:  aws.String(logGroup),
		LogStreamName: aws.String(*logStream),
	}
	resp, _ := svc.GetLogEvents(params)

	// Pretty-print the response data.
	fmt.Println(resp)
	return resp.Events
}

func GetLogStream(session *session.Session, region string, logGroup string) *string {
	svc := cloudwatchlogs.New(session, aws.NewConfig().WithRegion(region))

	params := &cloudwatchlogs.DescribeLogStreamsInput{
		LogGroupName: aws.String(logGroup),
		Descending:   aws.Bool(true),
		OrderBy:      aws.String("LastEventTime"),
	}

	resp, _ := svc.DescribeLogStreams(params)

	stream := resp.LogStreams[0].LogStreamName

	// Pretty-print the response data.
	fmt.Println(resp)
	return stream
}
