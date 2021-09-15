provider "aws" {
  region = var.aws_region
  max_retries = 1
}

terraform {
  backend "s3" {
    bucket = "terraform-up-and-running-acs-state"
    key = "workspaces/terraform.tfstate"
    region = "eu-west-1"

    dynamodb_table = "terraform-up-and-running-locks"
    encrypt = true
  }
}

resource "aws_instance" "example" {
  ami = var.ami_ubuntu_21_04
  instance_type = "t2.micro"
}