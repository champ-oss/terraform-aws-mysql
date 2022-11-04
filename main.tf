locals {
  snapshot_timestamp = formatdate("'${var.name_prefix}-'YYYYMMDDHHmmss", timestamp())
  db_snapshot_source = var.db_snapshot_source_arn != null ? data.aws_db_snapshot.this[0].id : null
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

# snapshot type is manual and db identifier is set
data "aws_db_snapshot" "this" {
  count                  = var.db_snapshot_source_arn != null ? 1 : 0
  db_snapshot_identifier = var.db_snapshot_source_arn
  snapshot_type          = "manual"
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
  snapshot_identifier                 = var.snapshot_identifier != null ? var.snapshot_identifier : local.db_snapshot_source
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
      instance_class  # ignore instance class on upgrades
    ]
  }
}

resource "aws_db_instance" "replica" {
  count                               = var.enable_replica ? 1 : 0
  allocated_storage                   = var.allocated_storage
  instance_class                      = var.instance_class
  identifier                          = "${aws_db_instance.this.identifier}-replica"
  password                            = random_password.password.result
  parameter_group_name                = var.parameter_group_name
  skip_final_snapshot                 = var.skip_final_snapshot
  final_snapshot_identifier           = "${aws_db_instance.this.final_snapshot_identifier}-replica"
  maintenance_window                  = var.maintenance_window
  backup_window                       = var.backup_window
  max_allocated_storage               = var.max_allocated_storage
  monitoring_interval                 = var.monitoring_interval
  monitoring_role_arn                 = aws_iam_role.rds_enhanced_monitoring.arn
  performance_insights_enabled        = var.performance_insights_enabled
  storage_encrypted                   = var.storage_encrypted
  multi_az                            = var.multi_az
  publicly_accessible                 = var.publicly_accessible
  vpc_security_group_ids              = [aws_security_group.rds.id]
  backup_retention_period             = var.backup_retention_period
  apply_immediately                   = !var.protect
  allow_major_version_upgrade         = var.allow_major_version_upgrade
  auto_minor_version_upgrade          = var.auto_minor_version_upgrade
  deletion_protection                 = var.protect
  copy_tags_to_snapshot               = var.copy_tags_to_snapshot
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  delete_automated_backups            = var.delete_automated_backups
  replicate_source_db                 = aws_db_instance.this.identifier
  tags                                = merge(local.tags, var.tags)
}

resource "aws_db_subnet_group" "this" {
  name_prefix = "${var.name_prefix}-"
  subnet_ids  = var.private_subnet_ids
  tags        = merge(local.tags, var.tags)

  lifecycle {
    create_before_destroy = true
  }
}