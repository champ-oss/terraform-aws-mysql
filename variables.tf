variable "private_subnet_ids" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group#subnet_ids"
  type        = list(string)
}

variable "vpc_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group#vpc_id"
  type        = string
}

variable "source_security_group_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule#source_security_group_id"
  type        = string
}

variable "iam_auth_docker_tag" {
  description = "Docker tag of IAM Auth code to deploy"
  type        = string
  default     = "a5f43f9c4ab5d1b0be4923f58bff799e53d38753"
}

variable "cidr_blocks" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule#cidr_blocks"
  type        = list(string)
  default     = ["10.0.0.0/8"]
}

variable "tags" {
  description = "Map of tags to assign to resources"
  type        = map(string)
  default     = {}
}

variable "git" {
  description = "Name of the Git repo"
  type        = string
  default     = "terraform-aws-mysql"
}

variable "allocated_storage" {
  default     = 20
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#allocated_storage"
  type        = number
}

variable "engine_version" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#engine_version"
  type        = string
  default     = "8.0.27"
}

variable "instance_class" {
  default     = "db.t3.micro"
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#instance_class"
  type        = string
}

variable "database_name" {
  default     = "this"
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#name"
  type        = string
}

variable "name_prefix" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#identifier"
  default     = "mysqldb-test"
  type        = string
}

variable "name" {
  description = "lambda identifier"
  default     = "rds"
  type        = string
}

variable "username" {
  default     = "root"
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#username"
  type        = string
}

variable "multi_az" {
  default     = false
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#multi_az"
  type        = string
}

variable "backup_retention_period" {
  default     = 35
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#backup_retention_period"
  type        = number
}

variable "maintenance_window" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#maintenance_window"
  default     = "Sun:07:00-Sun:08:00"
  type        = string
}

variable "backup_window" {
  type        = string
  description = "When AWS can perform DB snapshots, can't overlap with maintenance window"
  default     = "06:00-06:30"
}

variable "max_allocated_storage" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#max_allocated_storage"
  default     = 100
  type        = number
}

variable "monitoring_interval" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#monitoring_interval"
  type        = number
  default     = 60
}

variable "engine" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#engine"
  default     = "mysql"
  type        = string
}

variable "parameter_group_name" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#parameter_group_name"
  type        = string
  default     = null
}

variable "performance_insights_enabled" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#performance_insights_enabled"
  default     = false
  type        = bool
}

variable "iam_database_authentication_enabled" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#iam_database_authentication_enabled"
  default     = true
  type        = bool
}

variable "iam_auth_lambda_enabled" {
  description = "enable or disable the lambda for setting up iam auth"
  default     = false
  type        = bool
}

variable "enable_lambda_cw_event" {
  description = "enable or disable cloudwatch event trigger for lambda"
  default     = true
  type        = bool
}

variable "enable_rds_metric_alarms" {
  description = "enable or disable metric alarms for rds"
  default     = false
  type        = bool
}

variable "publicly_accessible" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#publicly_accessible"
  type        = bool
  default     = false
}

variable "storage_encrypted" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#storage_encrypted"
  default     = true
  type        = bool
}

variable "allow_major_version_upgrade" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#allow_major_version_upgrade"
  default     = false
  type        = bool
}

variable "auto_minor_version_upgrade" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#auto_minor_version_upgrade"
  default     = false
  type        = bool
}

variable "protect" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#deletion_protection"
  default     = true
  type        = bool
}

variable "snapshot_identifier" {
  default     = null
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#snapshot_identifier"
  type        = string
}

variable "final_snapshot_identifier" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#final_snapshot_identifier"
  type        = string
  default     = null
}

variable "skip_final_snapshot" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#skip_final_snapshot"
  default     = false
  type        = bool
}

variable "copy_tags_to_snapshot" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#copy_tags_to_snapshot"
  default     = true
  type        = bool
}

variable "delete_automated_backups" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#delete_automated_backups"
  default     = false
  type        = bool
}

variable "mysql_iam_read_username" {
  description = "read only user to be created via lambda function"
  type        = string
  default     = "db_iam_read"
}

variable "mysql_iam_admin_username" {
  description = "admin user to be created via lambda function"
  type        = string
  default     = "db_iam_admin"
}

variable "schedule_expression" {
  description = "event schedule for lambda"
  type        = string
  default     = "cron(0 10 ? * 1 *)" # lambda executes every Sunday at 10am UTC
}

variable "evaluation_periods" {
  description = "admin user to be created via lambda function"
  type        = number
  default     = 1
}

variable "period" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm#period"
  type        = number
  default     = 300 # in seconds
}

variable "ebs_io_balance_threshold" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm#threshold"
  type        = number
  default     = 30
}

variable "burst_balance_threshold" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm#threshold"
  type        = number
  default     = 30
}

variable "cpu_threshold" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm#threshold"
  type        = number
  default     = 90
}

variable "memory_threshold" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm#threshold"
  type        = number
  default     = 32 # MB
}

variable "ebs_byte_balance_threshold" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm#threshold"
  type        = number
  default     = 30
}

variable "alarms_email" {
  description = "rds alarm email"
  type        = string
  default     = null
}

variable "db_snapshot_source_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/db_snapshot#db_instance_identifier"
  type        = string
  default     = null
}

variable "enable_replica" {
  description = "Create a read replica for the primary database"
  type        = bool
  default     = false
}

variable "replica_instance_class" {
  default     = "db.t4g.micro"
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#instance_class"
  type        = string
}

variable "create_dms_endpoint" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_endpoint"
  type        = bool
  default     = false
}

variable "dms_endpoint_type" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_endpoint#endpoint_type"
  type        = string
  default     = "source"
}