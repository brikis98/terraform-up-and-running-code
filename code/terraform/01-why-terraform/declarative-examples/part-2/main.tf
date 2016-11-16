provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  count         = 15
  ami           = "ami-40d28157"
  instance_type = "t2.micro"
}
