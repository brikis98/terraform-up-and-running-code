terraform {
  required_version = ">= 0.8, < 0.9"
}

provider "aws" {
  region = "${var.aws_region}"
}

module "webserver_cluster" {
  source = "../../../../modules/services/webserver-cluster"

  ami         = "${data.aws_ami.ubuntu.id}"
  server_text = "Hello, World"

  aws_region             = "${var.aws_region}"
  cluster_name           = "${var.cluster_name}"
  db_remote_state_bucket = "${var.db_remote_state_bucket}"
  db_remote_state_key    = "${var.db_remote_state_key}"

  instance_type      = "m4.large"
  min_size           = 2
  max_size           = 10
  enable_autoscaling = true
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "image-type"
    values = ["machine"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }
}
