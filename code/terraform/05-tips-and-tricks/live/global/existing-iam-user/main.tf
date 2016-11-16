provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "existing_user" {
  # TODO: you should change this to the username of an IAM user that already
  # exists so you can practice using the terraform import command
  name = "yevgeniy.brikman"
}
