terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

module "users" {
  source = "../../../modules/landing-zone/iam-user"

  count     = length(var.user_names)
  user_name = var.user_names[count.index]
}
