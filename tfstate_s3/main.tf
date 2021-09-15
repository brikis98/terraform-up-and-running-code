provider "aws" {
  region = "eu-west-1"
  max_retries = 1
}

#
# Shared Terraform state bucket
#

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-up-and-running-acs-state"

  # Prevent accidental removal of this S3 bucket
  lifecycle {
    prevent_destroy = true
  }

  # Enable versioning of state files
  versioning {
    enabled = true
  }

  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

#
# DynamoDB Locking for Terraform state file
#

resource "aws_dynamodb_table" "terraform_locks" {
  hash_key = "LockID"
  name = "terraform-up-and-running-locks"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}

# Configured once the lock was created

terraform {
  backend "s3" {
    bucket = "terraform-up-and-running-acs-state"
    key = "global/s3/terraform.tfstate"
    region = "eu-west-1"

    dynamodb_table = "terraform-up-and-running-locks"
    encrypt = true
  }
}
