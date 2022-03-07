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

module "alb" {
  source = "../../modules/networking/alb"

  alb_name   = var.alb_name

  subnet_ids = data.aws_subnets.default.ids
}
