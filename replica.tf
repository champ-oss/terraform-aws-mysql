resource "aws_db_instance" "replica" {
  count                               = var.enable_replica ? 1 : 0
  replicate_source_db                 = aws_db_instance.this.identifier
  instance_class                      = var.replica_instance_class
  identifier                          = "${aws_db_instance.this.identifier}-replica"
  parameter_group_name                = var.parameter_group_name
  skip_final_snapshot                 = true
  maintenance_window                  = var.maintenance_window
  backup_window                       = var.backup_window
  max_allocated_storage               = var.max_allocated_storage
  monitoring_interval                 = var.monitoring_interval
  monitoring_role_arn                 = aws_iam_role.rds_enhanced_monitoring.arn
  performance_insights_enabled        = var.performance_insights_enabled
  storage_encrypted                   = var.storage_encrypted
  publicly_accessible                 = var.publicly_accessible
  vpc_security_group_ids              = [aws_security_group.rds.id]
  backup_retention_period             = 0
  apply_immediately                   = true
  allow_major_version_upgrade         = var.allow_major_version_upgrade
  auto_minor_version_upgrade          = var.auto_minor_version_upgrade
  deletion_protection                 = false
  copy_tags_to_snapshot               = var.copy_tags_to_snapshot
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  tags                                = merge(local.tags, var.tags)
}
