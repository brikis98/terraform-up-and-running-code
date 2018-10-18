terraform {
  required_version = ">= 0.11, < 0.12"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0977029b5b13f3d08"
  instance_type = "t2.micro"

  tags {
    Name = "terraform-example"
  }
}
