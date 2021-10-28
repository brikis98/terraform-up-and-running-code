provider "aws" {
  region = "eu-west-1"
}

module "webserver-cluster" {
  source = "../../../modules/services/webserver-cluster"

  cluster_name = "webservers-stage"
  db_remote_state_bucket = "terraform-up-and-running-acs-state"
  db_remote_state_key = "stage/s3/terraform.tfstate"
}

