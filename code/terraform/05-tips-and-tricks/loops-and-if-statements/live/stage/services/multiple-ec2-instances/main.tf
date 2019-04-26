terraform {
  required_version = ">= 0.11, < 0.12"
  backend "s3" {
    bucket  = "terraform-up-and-running-state"
    key     = "stage/services/webserver-cluster/terraform.tfstate"
    encrypt = true
    dynamodb_table = "terraform-state-lock-dynamo"
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_availability_zones" "all" {}

resource "aws_instance" "example" {
  count             = "${var.num_availability_zones}"
  availability_zone = "${element(data.aws_availability_zones.all.names, count.index)}"

  ami           = "ami-0977029b5b13f3d08"
  instance_type = "t2.micro"
}
