# terraform-aws-mysql

A Terraform module for deploying AWS RDS MySQL databases

[![.github/workflows/module.yml](https://github.com/champ-oss/terraform-aws-mysql/actions/workflows/module.yml/badge.svg?branch=main)](https://github.com/champ-oss/terraform-aws-mysql/actions/workflows/module.yml)
[![.github/workflows/lint.yml](https://github.com/champ-oss/terraform-aws-mysql/actions/workflows/lint.yml/badge.svg?branch=main)](https://github.com/champ-oss/terraform-aws-mysql/actions/workflows/lint.yml)
[![.github/workflows/sonar.yml](https://github.com/champ-oss/terraform-aws-mysql/actions/workflows/sonar.yml/badge.svg)](https://github.com/champ-oss/terraform-aws-mysql/actions/workflows/sonar.yml)

[![SonarCloud](https://sonarcloud.io/images/project_badges/sonarcloud-black.svg)](https://sonarcloud.io/summary/new_code?id=terraform-aws-mysql_champ-oss)

[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=terraform-aws-mysql_champ-oss&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=terraform-aws-mysql_champ-oss)
[![Vulnerabilities](https://sonarcloud.io/api/project_badges/measure?project=terraform-aws-mysql_champ-oss&metric=vulnerabilities)](https://sonarcloud.io/summary/new_code?id=terraform-aws-mysql_champ-oss)
[![Reliability Rating](https://sonarcloud.io/api/project_badges/measure?project=terraform-aws-mysql_champ-oss&metric=reliability_rating)](https://sonarcloud.io/summary/new_code?id=terraform-aws-mysql_champ-oss)

## Example Usage

See the `examples/` folder

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

## Features



## Updating `iam_auth` Python Requirements

1. Create a virtual environment by running:
   1. `cd iam_auth`
   2. `python3 -m venv venv`
   3. `. ./venv/bin/activate`
2. Install pip dependencies into the virtual environment by running:
   1. `./venv/bin/pip install -r requirements.txt`
3. Update or add dependencies to `requirements.txt` and then install using the previous step
4. Freeze the full list of dependencies by running:
   1. `./venv/bin/pip freeze > requirements.txt `
5. Commit the changed `requirements.txt` file.



## Contributing


