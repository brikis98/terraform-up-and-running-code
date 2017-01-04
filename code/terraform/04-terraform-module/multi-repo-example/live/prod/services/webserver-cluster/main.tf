terraform {
  required_version = ">= 0.8, < 0.9"
}

provider "aws" {
  region = "us-east-1"
}

module "webserver_cluster" {
  source = "git@github.com:brikis98/terraform-up-and-running-code.git//code/terraform/04-terraform-module/module-example/modules/services/webserver-cluster?ref=v0.0.1"

  cluster_name           = "webservers-prod"
  db_remote_state_bucket = "${var.db_remote_state_bucket}"
  db_remote_state_key    = "${var.db_remote_state_key}"

  instance_type = "m4.large"
  min_size      = 2
  max_size      = 10
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  scheduled_action_name  = "scale-out-during-business-hours"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 10
  recurrence             = "0 9 * * *"
  autoscaling_group_name = "${module.webserver_cluster.asg_name}"
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  scheduled_action_name  = "scale-in-at-night"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 2
  recurrence             = "0 17 * * *"
  autoscaling_group_name = "${module.webserver_cluster.asg_name}"
}
