resource "aws_dms_endpoint" "this" {
  count         = var.create_dms_endpoint ? 1 : 0
  endpoint_id   = "${aws_db_instance.this.identifier}-dms-endpoint"
  endpoint_type = var.dms_endpoint_type
  engine_name   = var.engine
  database_name = var.database_name
  password      = random_password.password.result
  port          = aws_db_instance.this.port
  server_name   = aws_db_instance.this.address
  tags          = merge(local.tags, var.tags)
  username      = var.username

  timeouts {
    create = "60m"
    update = "60m"
    delete = "60m"
  }
}
