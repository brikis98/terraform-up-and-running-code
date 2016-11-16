provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  count         = 15
  ami           = "ami-408c7f28"
  instance_type = "t2.micro"
}
