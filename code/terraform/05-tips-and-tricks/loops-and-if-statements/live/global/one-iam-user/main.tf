terraform {
  required_version = ">= 0.8, < 0.9"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "example" {
  name = "neo"
}
