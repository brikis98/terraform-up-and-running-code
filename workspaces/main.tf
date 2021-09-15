provider "aws" {
  region = var.aws_region
  max_retries = 1
}

resource "aws_instance" "example" {
  ami = var.ami_ubuntu_21_04
  instance_type = "t2.micro"
}