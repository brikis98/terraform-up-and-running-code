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

module "webserver_cluster" {
  source = "../../../../modules/services/webserver-cluster-instance-refresh"

  ami         = "ami-0fb653ca2d3203ac1"

  server_text = var.server_text

  cluster_name           = var.cluster_name
  db_remote_state_bucket = var.db_remote_state_bucket
  db_remote_state_key    = var.db_remote_state_key

  instance_type      = "m4.large"
  min_size           = 2
  max_size           = 10
  enable_autoscaling = true
}

