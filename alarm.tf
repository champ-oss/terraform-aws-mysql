resource "aws_cloudwatch_metric_alarm" "ebs_byte_balance" {
  count               = var.enable_rds_metric_alarms ? 1 : 0
  alarm_name          = "rds-${aws_db_instance.this.id}-ebs-byte-balance"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "EBSByteBalance%"
  namespace           = "AWS/RDS"
  period              = var.period
  statistic           = "Average"
  threshold           = var.ebs_byte_balance_threshold
  alarm_description   = "cloud watch alarm for ebs byte balance: ${aws_db_instance.this.id}"
  alarm_actions       = ["${aws_sns_topic.this.arn}"]
  ok_actions          = ["${aws_sns_topic.this.arn}"]

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.this.id
  }
  tags = merge(local.tags, var.tags)
}

resource "aws_cloudwatch_metric_alarm" "ebs_io_balance" {
  count               = var.enable_rds_metric_alarms ? 1 : 0
  alarm_name          = "rds-${aws_db_instance.this.id}-ebs-io-balance"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "EBSIOBalance%"
  namespace           = "AWS/RDS"
  period              = var.period
  statistic           = "Average"
  threshold           = var.ebs_io_balance_threshold
  alarm_description   = "cloud watch alarm for ebs io balance: ${aws_db_instance.this.id}"
  alarm_actions       = ["${aws_sns_topic.this.arn}"]
  ok_actions          = ["${aws_sns_topic.this.arn}"]

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.this.id
  }
  tags = merge(local.tags, var.tags)
}

resource "aws_cloudwatch_metric_alarm" "burst_balance" {
  count               = var.enable_rds_metric_alarms ? 1 : 0
  alarm_name          = "rds-${aws_db_instance.this.id}-burst-balance"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "BurstBalance"
  namespace           = "AWS/RDS"
  period              = var.period
  statistic           = "Average"
  threshold           = var.burst_balance_threshold
  alarm_description   = "cloud watch alarm for burst balance: ${aws_db_instance.this.id}"
  alarm_actions       = ["${aws_sns_topic.this.arn}"]
  ok_actions          = ["${aws_sns_topic.this.arn}"]

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.this.id
  }
  tags = merge(local.tags, var.tags)
}
