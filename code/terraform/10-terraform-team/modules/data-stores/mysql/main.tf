provider "aws" {
  region = "us-east-2"
}

terraform {
  # Require any 1.x version of Terraform
  required_version = ">= 1.0.0, < 2.0.0"

  # Require an 3.x version of the AWS provider
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_db_instance" "example" {
  identifier_prefix   = "terraform-up-and-running"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  db_name             = var.db_name
  username            = var.db_username
  password            = var.db_password
  skip_final_snapshot = true
}
