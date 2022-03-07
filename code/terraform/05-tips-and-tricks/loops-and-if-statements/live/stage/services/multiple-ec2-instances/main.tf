terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "example_1" {
  count         = 3
  ami           = "ami-0fb653ca2d3203ac1"
  instance_type = "t2.micro"
}

resource "aws_instance" "example_2" {
  count             = length(data.aws_availability_zones.all.names)
  availability_zone = data.aws_availability_zones.all.names[count.index]
  ami               = "ami-0fb653ca2d3203ac1"
  instance_type     = "t2.micro"
}

data "aws_availability_zones" "all" {}

