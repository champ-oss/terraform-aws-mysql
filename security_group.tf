resource "aws_security_group" "rds" {
  name_prefix = "${var.name_prefix}-rds-"
  vpc_id      = var.vpc_id
  tags        = merge(local.tags, var.tags)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "from_sg" {
  description              = "ingress from security group"
  type                     = "ingress"
  from_port                = aws_db_instance.this.port
  to_port                  = aws_db_instance.this.port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds.id
  source_security_group_id = var.source_security_group_id
}

resource "aws_security_group_rule" "from_cidr" {
  description       = "ingress from cidr blocks"
  type              = "ingress"
  from_port         = aws_db_instance.this.port
  to_port           = aws_db_instance.this.port
  protocol          = "tcp"
  security_group_id = aws_security_group.rds.id
  cidr_blocks       = var.cidr_blocks
}
