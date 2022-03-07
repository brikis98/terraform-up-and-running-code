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
  alias  = "parent"
}

provider "aws" {
  region = "us-east-2"
  alias  = "child"

  assume_role {
    role_arn = var.child_iam_role_arn
  }
}

module "multi_account_example" {
  source = "../../modules/multi-account"

  providers = {
    aws.parent = aws.parent
    aws.child  = aws.child
  }
}
