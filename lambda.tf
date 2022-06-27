resource "random_string" "identifier" {
  length  = 5
  special = false
  upper   = false
  lower   = true
  number  = false
}

module "iam_auth_lambda" {
  source              = "github.com/champ-oss/terraform-aws-lambda.git?ref=v1.0.55-d0d7de4"
  git                 = var.git
  name                = "${var.name}-iam-auth-${random_string.identifier.result}"
  tags                = merge(local.tags, var.tags)
  description         = "iam auth rds database lambda function"
  enable_cw_event     = var.enable_lambda_cw_event
  schedule_expression = var.schedule_expression
  enable_vpc          = true
  private_subnet_ids  = var.private_subnet_ids
  filename            = "${path.module}/iam_auth/package.zip"
  source_code_hash    = filesha256("${path.module}/iam_auth/package.zip")
  handler             = "rds_iam_auth.lambda_handler"
  runtime             = "python3.9"
  vpc_id              = var.vpc_id # eni delete resource bug https://github.com/hashicorp/terraform-provider-aws/issues/10329
  environment = {
    DB_HOST         = aws_db_instance.this.endpoint
    DB_USERNAME     = var.username
    SSM_NAME        = aws_ssm_parameter.this.name
    RO_USER_NAME    = var.mysql_iam_read_username
    ADMIN_USER_NAME = var.mysql_iam_admin_username
  }
}
