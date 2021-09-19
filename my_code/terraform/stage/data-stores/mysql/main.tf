provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket  = "terraform-up-and-running-acs-state"
    key     = "stage/data-stores/mysql/terraform.tfstate"
    region = "eu-west-1"

    dynamodb_table = "terraform-up-and-running-locks"
    encrypt = true
  }
}

resource "aws_db_instance" "example" {
  identifier_prefix = "terraform-up-and-running"
  engine = "mysql"
  allocated_storage = 10  # GB
  instance_class = "db.t2.micro"
  name = "example_database"
  username = "admin"

  password = var.db_password
}

