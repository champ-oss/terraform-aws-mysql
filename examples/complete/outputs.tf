output "password_ssm_name" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter#name"
  value       = module.this.password_ssm_name
}

output "password" {
  description = "https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password"
  value       = module.this.password
  sensitive   = true
}

output "region" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region#name"
  value       = data.aws_region.current.name
}

output "identifier" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#identifier"
  value       = module.this.identifier
}

output "resource_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#resource_id"
  value       = module.this.resource_id
}

output "final_snapshot_identifier" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#final_snapshot_identifier"
  value       = module.this.final_snapshot_identifier
}

output "arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#arn"
  value       = module.this.arn
}