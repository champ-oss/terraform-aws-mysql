provider "aws" {
  region = "eu-west-1"
}

data "aws_region" "current" {}

module "vpc" {
  source                   = "github.com/champ-oss/terraform-aws-vpc.git?ref=v1.0.41-10101c8"
  git                      = var.git
  availability_zones_count = 2
  retention_in_days        = 1
}

resource "aws_security_group" "test" {
  name_prefix = "test-rds-"
  vpc_id      = module.vpc.vpc_id
}

module "this" {
  source                              = "../../"
  name_prefix                         = var.git
  private_subnet_ids                  = module.vpc.private_subnets_ids
  source_security_group_id            = aws_security_group.test.id
  vpc_id                              = module.vpc.vpc_id
  protect                             = false
  multi_az                            = false
  allocated_storage                   = 5
  instance_class                      = "db.t3.micro"
  iam_database_authentication_enabled = true
  iam_auth_lambda_enabled             = true
  enable_lambda_cw_event              = true
  schedule_expression                 = "rate(1 minute)"
  delete_automated_backups            = true
  skip_final_snapshot                 = true
  backup_retention_period             = 1
  enable_replica                      = true
  create_dms_endpoint                 = true
}