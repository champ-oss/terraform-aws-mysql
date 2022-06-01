resource "aws_ssm_parameter" "this" {
  name        = "${var.name_prefix}-mysql"
  description = "RDS password"
  type        = "SecureString"
  value       = random_password.password.result
  tags        = merge(local.tags, var.tags)

  lifecycle {
    create_before_destroy = true
  }
}
