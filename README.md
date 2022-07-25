# terraform-aws-mysql

A Terraform module for deploying AWS RDS MySQL databases

[![.github/workflows/module.yml](https://github.com/champ-oss/terraform-aws-mysql/actions/workflows/module.yml/badge.svg?branch=main)](https://github.com/champ-oss/terraform-aws-mysql/actions/workflows/module.yml)
[![.github/workflows/lint.yml](https://github.com/champ-oss/terraform-aws-mysql/actions/workflows/lint.yml/badge.svg?branch=main)](https://github.com/champ-oss/terraform-aws-mysql/actions/workflows/lint.yml)
[![.github/workflows/sonar.yml](https://github.com/champ-oss/terraform-aws-mysql/actions/workflows/sonar.yml/badge.svg)](https://github.com/champ-oss/terraform-aws-mysql/actions/workflows/sonar.yml)

[![SonarCloud](https://sonarcloud.io/images/project_badges/sonarcloud-black.svg)](https://sonarcloud.io/summary/new_code?id=terraform-aws-mysql_champ-oss)

[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=terraform-aws-mysql_champ-oss&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=terraform-aws-mysql_champ-oss)
[![Vulnerabilities](https://sonarcloud.io/api/project_badges/measure?project=terraform-aws-mysql_champ-oss&metric=vulnerabilities)](https://sonarcloud.io/summary/new_code?id=terraform-aws-mysql_champ-oss)
[![Reliability Rating](https://sonarcloud.io/api/project_badges/measure?project=terraform-aws-mysql_champ-oss&metric=reliability_rating)](https://sonarcloud.io/summary/new_code?id=terraform-aws-mysql_champ-oss)

## Example Usage

See the `examples/` folder

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.9.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.9.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_auth_lambda"></a> [iam\_auth\_lambda](#module\_iam\_auth\_lambda) | github.com/champ-oss/terraform-aws-lambda.git | v1.0.71-2e2e648 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.burst_balance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.cpu_warning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.ebs_byte_balance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.ebs_io_balance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.memory_warning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_db_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_subnet_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_iam_role.rds_enhanced_monitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.rds_enhanced_monitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.from_cidr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.from_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_sns_topic.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_ssm_parameter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_string.identifier](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_iam_policy_document.rds_enhanced_monitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarms_email"></a> [alarms\_email](#input\_alarms\_email) | rds alarm email | `string` | `null` | no |
| <a name="input_allocated_storage"></a> [allocated\_storage](#input\_allocated\_storage) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#allocated_storage | `number` | `20` | no |
| <a name="input_allow_major_version_upgrade"></a> [allow\_major\_version\_upgrade](#input\_allow\_major\_version\_upgrade) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#allow_major_version_upgrade | `bool` | `false` | no |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input\_auto\_minor\_version\_upgrade) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#auto_minor_version_upgrade | `bool` | `false` | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#backup_retention_period | `number` | `35` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | When AWS can perform DB snapshots, can't overlap with maintenance window | `string` | `"06:00-06:30"` | no |
| <a name="input_burst_balance_threshold"></a> [burst\_balance\_threshold](#input\_burst\_balance\_threshold) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm#threshold | `number` | `30` | no |
| <a name="input_cidr_blocks"></a> [cidr\_blocks](#input\_cidr\_blocks) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule#cidr_blocks | `list(string)` | <pre>[<br>  "10.0.0.0/8"<br>]</pre> | no |
| <a name="input_copy_tags_to_snapshot"></a> [copy\_tags\_to\_snapshot](#input\_copy\_tags\_to\_snapshot) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#copy_tags_to_snapshot | `bool` | `true` | no |
| <a name="input_cpu_threshold"></a> [cpu\_threshold](#input\_cpu\_threshold) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm#threshold | `number` | `90` | no |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#name | `string` | `"this"` | no |
| <a name="input_delete_automated_backups"></a> [delete\_automated\_backups](#input\_delete\_automated\_backups) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#delete_automated_backups | `bool` | `false` | no |
| <a name="input_ebs_byte_balance_threshold"></a> [ebs\_byte\_balance\_threshold](#input\_ebs\_byte\_balance\_threshold) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm#threshold | `number` | `30` | no |
| <a name="input_ebs_io_balance_threshold"></a> [ebs\_io\_balance\_threshold](#input\_ebs\_io\_balance\_threshold) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm#threshold | `number` | `30` | no |
| <a name="input_enable_lambda_cw_event"></a> [enable\_lambda\_cw\_event](#input\_enable\_lambda\_cw\_event) | enable or disable cloudwatch event trigger for lambda | `bool` | `true` | no |
| <a name="input_enable_rds_metric_alarms"></a> [enable\_rds\_metric\_alarms](#input\_enable\_rds\_metric\_alarms) | enable or disable metric alarms for rds | `bool` | `false` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#engine | `string` | `"mysql"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#engine_version | `string` | `"8.0.27"` | no |
| <a name="input_evaluation_periods"></a> [evaluation\_periods](#input\_evaluation\_periods) | admin user to be created via lambda function | `number` | `1` | no |
| <a name="input_final_snapshot_identifier"></a> [final\_snapshot\_identifier](#input\_final\_snapshot\_identifier) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#final_snapshot_identifier | `string` | `null` | no |
| <a name="input_git"></a> [git](#input\_git) | Name of the Git repo | `string` | `"terraform-aws-mysql"` | no |
| <a name="input_iam_auth_docker_tag"></a> [iam\_auth\_docker\_tag](#input\_iam\_auth\_docker\_tag) | Docker tag of IAM Auth code to deploy | `string` | `"158524236d98a0f5582a11864199ec6bf4980fb0"` | no |
| <a name="input_iam_auth_lambda_enabled"></a> [iam\_auth\_lambda\_enabled](#input\_iam\_auth\_lambda\_enabled) | enable or disable the lambda for setting up iam auth | `bool` | `false` | no |
| <a name="input_iam_database_authentication_enabled"></a> [iam\_database\_authentication\_enabled](#input\_iam\_database\_authentication\_enabled) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#iam_database_authentication_enabled | `bool` | `true` | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#instance_class | `string` | `"db.t3.micro"` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#maintenance_window | `string` | `"Sun:07:00-Sun:08:00"` | no |
| <a name="input_max_allocated_storage"></a> [max\_allocated\_storage](#input\_max\_allocated\_storage) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#max_allocated_storage | `number` | `100` | no |
| <a name="input_memory_threshold"></a> [memory\_threshold](#input\_memory\_threshold) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm#threshold | `number` | `32` | no |
| <a name="input_monitoring_interval"></a> [monitoring\_interval](#input\_monitoring\_interval) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#monitoring_interval | `number` | `60` | no |
| <a name="input_multi_az"></a> [multi\_az](#input\_multi\_az) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#multi_az | `string` | `false` | no |
| <a name="input_mysql_iam_admin_username"></a> [mysql\_iam\_admin\_username](#input\_mysql\_iam\_admin\_username) | admin user to be created via lambda function | `string` | `"db_iam_admin"` | no |
| <a name="input_mysql_iam_read_username"></a> [mysql\_iam\_read\_username](#input\_mysql\_iam\_read\_username) | read only user to be created via lambda function | `string` | `"db_iam_read"` | no |
| <a name="input_name"></a> [name](#input\_name) | lambda identifier | `string` | `"rds"` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#identifier | `string` | `"mysqldb-test"` | no |
| <a name="input_parameter_group_name"></a> [parameter\_group\_name](#input\_parameter\_group\_name) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#parameter_group_name | `string` | `null` | no |
| <a name="input_performance_insights_enabled"></a> [performance\_insights\_enabled](#input\_performance\_insights\_enabled) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#performance_insights_enabled | `bool` | `false` | no |
| <a name="input_period"></a> [period](#input\_period) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm#period | `number` | `300` | no |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group#subnet_ids | `list(string)` | n/a | yes |
| <a name="input_protect"></a> [protect](#input\_protect) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#deletion_protection | `bool` | `true` | no |
| <a name="input_publicly_accessible"></a> [publicly\_accessible](#input\_publicly\_accessible) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#publicly_accessible | `bool` | `false` | no |
| <a name="input_schedule_expression"></a> [schedule\_expression](#input\_schedule\_expression) | event schedule for lambda | `string` | `"cron(0 10 ? * 1 *)"` | no |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#skip_final_snapshot | `bool` | `false` | no |
| <a name="input_snapshot_identifier"></a> [snapshot\_identifier](#input\_snapshot\_identifier) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#snapshot_identifier | `string` | `null` | no |
| <a name="input_source_security_group_id"></a> [source\_security\_group\_id](#input\_source\_security\_group\_id) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule#source_security_group_id | `string` | n/a | yes |
| <a name="input_storage_encrypted"></a> [storage\_encrypted](#input\_storage\_encrypted) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#storage_encrypted | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to assign to resources | `map(string)` | `{}` | no |
| <a name="input_username"></a> [username](#input\_username) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#username | `string` | `"root"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group#vpc_id | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_address"></a> [address](#output\_address) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#address |
| <a name="output_arn"></a> [arn](#output\_arn) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#arn |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#endpoint |
| <a name="output_final_snapshot_identifier"></a> [final\_snapshot\_identifier](#output\_final\_snapshot\_identifier) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#final_snapshot_identifier |
| <a name="output_identifier"></a> [identifier](#output\_identifier) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#identifier |
| <a name="output_lambda_cloudwatch_log_group"></a> [lambda\_cloudwatch\_log\_group](#output\_lambda\_cloudwatch\_log\_group) | lambda cloudwatch log group |
| <a name="output_master_username"></a> [master\_username](#output\_master\_username) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#username |
| <a name="output_password"></a> [password](#output\_password) | https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password |
| <a name="output_password_ssm_name"></a> [password\_ssm\_name](#output\_password\_ssm\_name) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter#name |
| <a name="output_port"></a> [port](#output\_port) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#port |
| <a name="output_rds_instance_id"></a> [rds\_instance\_id](#output\_rds\_instance\_id) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#id |
| <a name="output_rds_resource_id"></a> [rds\_resource\_id](#output\_rds\_resource\_id) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#resource_id |
| <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#resource_id |
| <a name="output_status"></a> [status](#output\_status) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#status |
<!-- END_TF_DOCS -->

## Features



## Updating `iam_auth` Python Requirements

1. Create a virtual environment by running:
   1. `cd iam_auth`
   2. `python3 -m venv venv`
   3. `. ./venv/bin/activate`
2. Install pip dependencies into the virtual environment by running:
   1. `./venv/bin/pip install -r requirements.txt`
3. Update or add dependencies to `requirements.txt` and then install using the previous step
4. Freeze the full list of dependencies by running:
   1. `./venv/bin/pip freeze > requirements.txt `
5. Commit the changed `requirements.txt` file.



## Contributing


