provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "${var.version}"
  instance_type = "t2.micro"
}
