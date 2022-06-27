variable "git" {
  description = "Name of the Git repo"
  type        = string
  default     = "terraform-aws-mysql"
}

variable "snapshot_identifier" {
  default     = null
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#snapshot_identifier"
  type        = string
}

variable "name_prefix" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#identifier"
  default     = null
  type        = string
}