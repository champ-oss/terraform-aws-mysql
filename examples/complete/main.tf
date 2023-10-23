data "aws_vpcs" "this" {
  tags = {
    purpose = "vega"
  }
}

data "aws_subnets" "this" {
  tags = {
    purpose = "vega"
    Type    = "Private"
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpcs.this.ids[0]]
  }
}

resource "aws_security_group" "test" {
  name_prefix = "test-rds-"
  vpc_id      = data.aws_vpcs.this.ids[0]
}

module "this" {
  source                              = "../../"
  name_prefix                         = "terraform-aws-mysql"
  private_subnet_ids                  = data.aws_subnets.this.ids
  source_security_group_id            = aws_security_group.test.id
  vpc_id                              = data.aws_vpcs.this.ids[0]
  protect                             = false
  multi_az                            = false
  allocated_storage                   = 5
  instance_class                      = "db.t3.micro"
  iam_database_authentication_enabled = true
  delete_automated_backups            = true
  skip_final_snapshot                 = true
  backup_retention_period             = 1
  enable_replica                      = true
}
