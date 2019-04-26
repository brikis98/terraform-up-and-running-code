terraform {
  required_version = ">= 0.11, < 0.12"
  backend "s3" {
    bucket  = "terraform-up-and-running-state"
    key     = "stage/data-stores/mysql/terraform.tfstate"
    encrypt = true
    dynamodb_table = "terraform-state-lock-dynamo"
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_db_instance" "example" {
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  name                = "example_database"
  username            = "admin"
  password            = "${var.db_password}"
  skip_final_snapshot = true
}
