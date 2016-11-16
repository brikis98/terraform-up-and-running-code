provider "aws" {
  region = "us-east-1"
}

module "search_service" {
  source = "../../../../modules/services/webserver-cluster"

  cluster_name           = "search-service-prod"
  db_remote_state_bucket = "(YOUR_BUCKET_NAME)"
  db_remote_state_key    = "prod/data-stores/mysql/terraform.tfstate"

  instance_type = "x1.16xlarge"
  min_size      = 4
  max_size      = 4

  enable_autoscaling   = false
  enable_new_user_data = false
}

module "profile_service" {
  source = "../../../../modules/services/webserver-cluster"

  cluster_name           = "profile-service-prod"
  db_remote_state_bucket = "(YOUR_BUCKET_NAME)"
  db_remote_state_key    = "prod/data-stores/mysql/terraform.tfstate"

  instance_type = "m4.large"
  min_size      = 12
  max_size      = 40

  enable_autoscaling   = true
  enable_new_user_data = true
}
