resource "aws_sns_topic" "this" {
  name = "${var.name}-alarms"
}

resource "aws_sns_topic_subscription" "this" {
  depends_on = [
    aws_sns_topic.this
  ]
  topic_arn = aws_sns_topic.this.arn
  protocol  = "email"
  endpoint  = var.alarms_email
}
