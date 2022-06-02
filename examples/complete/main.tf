provider "aws" {
  region = "us-west-1"
}

data "aws_region" "current" {}

module "vpc" {
  source                   = "github.com/champ-oss/terraform-aws-vpc.git?ref=v1.0.13-58fcd2a"
  git                      = var.git
  availability_zones_count = 2
  retention_in_days        = 1
}

resource "aws_security_group" "test" {
  name_prefix = "test-rds-"
  vpc_id      = module.vpc.vpc_id
}

resource "random_string" "identifier" {
  length  = 5
  special = false
  upper   = false
  lower   = true
  number  = true
}

module "this" {
  source                              = "../../"
  name_prefix                         = var.name_prefix != null ? var.name_prefix : "${var.git}-${random_string.identifier.result}"
  private_subnet_ids                  = module.vpc.private_subnets_ids
  source_security_group_id            = aws_security_group.test.id
  vpc_id                              = module.vpc.vpc_id
  protect                             = false
  multi_az                            = false
  allocated_storage                   = 5
  instance_class                      = "db.t3.micro"
  snapshot_identifier                 = var.snapshot_identifier
  iam_database_authentication_enabled = true
  enable_lambda_cw_event              = true
  schedule_expression                 = "rate(1 minute)"
  iam_auth_docker_tag                 = var.iam_auth_docker_tag
}
