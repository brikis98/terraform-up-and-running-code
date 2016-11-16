provider "aws" {
  region = "${var.aws_region}"
}

module "webserver_cluster" {
  source = "../../../../modules/services/webserver-cluster"

  aws_region             = "${var.aws_region}"
  cluster_name           = "${var.cluster_name}"
  db_remote_state_bucket = "${var.db_remote_state_bucket}"
  db_remote_state_key    = "${var.db_remote_state_key}"

  instance_type = "m4.large"
  min_size      = 2
  max_size      = 10

  enable_autoscaling   = true
  enable_new_user_data = false
}
