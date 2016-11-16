variable "aws_region" {
  description = "The AWS region to use"
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  default     = "webservers-prod"
}

variable "db_remote_state_bucket" {
  description = "The S3 bucket used for the database's remote state"
}

variable "db_remote_state_key" {
  description = "The path for the database's remote state in S3"
  default     = "prod/data-stores/mysql/terraform.tfstate"
}
