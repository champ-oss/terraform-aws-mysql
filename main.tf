locals {
  snapshot_timestamp = formatdate("'${var.name_prefix}-'YYYYMMDDHHmmss", timestamp())
  tags = {
    cost    = "rds"
    creator = "terraform"
    git     = var.git
  }
}

# Database root password
resource "random_password" "password" {
  length  = 32
  special = false

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_db_snapshot" "this" {
  most_recent            = true
  db_instance_identifier = var.db_instance_identifier
}

resource "aws_db_instance" "this" {
  allocated_storage                   = var.allocated_storage
  engine                              = var.engine
  engine_version                      = var.engine_version
  instance_class                      = var.instance_class
  name                                = var.database_name
  username                            = var.username
  identifier                          = var.name_prefix
  password                            = random_password.password.result
  parameter_group_name                = var.parameter_group_name
  skip_final_snapshot                 = var.skip_final_snapshot
  final_snapshot_identifier           = var.final_snapshot_identifier != null ? var.final_snapshot_identifier : local.snapshot_timestamp
  maintenance_window                  = var.maintenance_window
  backup_window                       = var.backup_window
  max_allocated_storage               = var.max_allocated_storage
  monitoring_interval                 = var.monitoring_interval
  monitoring_role_arn                 = aws_iam_role.rds_enhanced_monitoring.arn
  performance_insights_enabled        = var.performance_insights_enabled
  storage_encrypted                   = var.storage_encrypted
  snapshot_identifier                 = var.snapshot_identifier != null ? var.snapshot_identifier : data.aws_db_snapshot.this.id
  multi_az                            = var.multi_az
  publicly_accessible                 = var.publicly_accessible
  db_subnet_group_name                = aws_db_subnet_group.this.id
  vpc_security_group_ids              = [aws_security_group.rds.id]
  backup_retention_period             = var.backup_retention_period
  apply_immediately                   = !var.protect
  allow_major_version_upgrade         = var.allow_major_version_upgrade
  auto_minor_version_upgrade          = var.auto_minor_version_upgrade
  deletion_protection                 = var.protect
  copy_tags_to_snapshot               = var.copy_tags_to_snapshot
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  delete_automated_backups            = var.delete_automated_backups
  tags                                = merge(local.tags, var.tags)

  lifecycle {
    ignore_changes = [
      identifier,
      identifier_prefix,
      final_snapshot_identifier,
      name,           # snapshots with a different name will show perpetual drift
      username,       # snapshots with a different username will show perpetual drift
      engine_version, # ignore drift for upgrades
    ]
  }
}

resource "aws_db_subnet_group" "this" {
  name_prefix = "${var.name_prefix}-"
  subnet_ids  = var.private_subnet_ids
  tags        = merge(local.tags, var.tags)

  lifecycle {
    create_before_destroy = true
  }
}
