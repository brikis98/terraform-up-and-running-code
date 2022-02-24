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
  # TODO: replace ref with version number
  source = "github.com/brikis98/terraform-up-and-running-code//code/terraform/07-testing-terraform-code/modules/networking/alb?ref=master"

  # source = "../../modules/networking/alb"

  alb_name   = "example-alb"
  subnet_ids = data.aws_subnets.default.ids
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}