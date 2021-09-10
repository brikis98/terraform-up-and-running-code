provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "example" {
  ami = "ami-00622de605b25a7d6"  # Ubuntu 21.04 amd64
  instance_type = "t2.micro"

  tags = {
    Name = "terraform-example"
  }
}