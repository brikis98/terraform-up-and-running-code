provider "aws" {
  region = "us-east-1"
}

provider "dnsimple" {
  token = "fake-token"
  email = "fake-email"
}

resource "aws_instance" "example" {
  ami           = "ami-40d28157"
  instance_type = "t2.micro"
}

resource "dnsimple_record" "example" {
  domain = "example.com"
  name   = "test"
  value  = "${aws_instance.example.public_ip}"
  type   = "A"
}
