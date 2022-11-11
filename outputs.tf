output "identifier" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#identifier"
  value       = aws_db_instance.this.identifier
}

output "resource_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#resource_id"
  value       = aws_db_instance.this.resource_id
}

output "password" {
  description = "https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password"
  value       = random_password.password.result
  sensitive   = true
}

output "endpoint" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#endpoint"
  value       = aws_db_instance.this.endpoint
}

output "address" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#address"
  value       = aws_db_instance.this.address
}

output "port" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#port"
  value       = aws_db_instance.this.port
}

output "arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#arn"
  value       = aws_db_instance.this.arn
}

output "rds_instance_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#id"
  value       = aws_db_instance.this.id
}

output "rds_resource_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#resource_id"
  value       = aws_db_instance.this.resource_id
}

output "status" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#status"
  value       = aws_db_instance.this.status
}

output "master_username" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#username"
  value       = aws_db_instance.this.username
}

output "password_ssm_name" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter#name"
  value       = aws_ssm_parameter.this.name
}

output "final_snapshot_identifier" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#final_snapshot_identifier"
  value       = aws_db_instance.this.final_snapshot_identifier
}

output "lambda_cloudwatch_log_group" {
  description = "lambda cloudwatch log group"
  value       = var.iam_auth_lambda_enabled ? module.iam_auth_lambda[0].cloudwatch_log_group : ""
}

output "dms_endpoint_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_endpoint#endpoint_arn"
  value       = aws_dms_endpoint.this.endpoint_arn
}
