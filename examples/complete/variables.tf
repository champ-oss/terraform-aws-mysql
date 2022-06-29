variable "git" {
  description = "Name of the Git repo"
  type        = string
  default     = "terraform-aws-mysql"
}

variable "iam_auth_docker_tag" {
  description = "IAM Auth Docker tag to deploy"
  type        = string
}