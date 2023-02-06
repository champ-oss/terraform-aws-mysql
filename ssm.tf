resource "aws_ssm_parameter" "this" {
  name        = "${var.name_prefix}-mysql"
  description = "RDS password"
  type        = "SecureString"
  value       = random_password.password.result
  tags = merge({
    master_username    = aws_db_instance.this.username
    port               = aws_db_instance.this.port
    endpoint           = aws_db_instance.this.endpoint
    address            = aws_db_instance.this.address
    cluster_identifier = aws_db_instance.this.identifier
  }, local.tags, var.tags)

  lifecycle {
    create_before_destroy = true
  }
}
