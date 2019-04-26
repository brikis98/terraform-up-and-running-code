terraform {
  required_version = ">= 0.11, < 0.12"
  backend "s3" {
    bucket  = "terraform-up-and-running-state"
    key     = "stage/services/webserver-cluster/terraform.tfstate"
    encrypt = true
    dynamodb_table = "terraform-state-lock-dynamo"
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "existing_user" {
  # You should change this to the username of an IAM user that already
  # exists so you can practice using the terraform import command
  name = "yevgeniy.brikman"
}
