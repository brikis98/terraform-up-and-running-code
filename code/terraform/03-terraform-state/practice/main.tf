terraform {
  required_version = ">= 1.0.0, < 2.0.0"
  required_providers {
      aws = {
          source = "hashicorp/aws"
          version = "~> 4.0"
      }
  }
  #first run terraform apply with the below backend block commented. 
  #   - This will create the S3 bucket and DynamoDB needed to store the terraform state
  #AFter that uncomment the below backend block and run "terraform init". This will export the staefile to AWS S3 backend 
  backend "s3" {

    bucket = "pp-terraform-up-and-running-state"
    key = "global/s3/terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt = true
    
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "pp-terraform-up-and-running-state"

  #prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = true
  }
}

#enable versioning so you can see the full revision history of your state files
resource "aws_s3_bucket_versioning" "versioning_enabled" {
    bucket = aws_s3_bucket.terraform_state.id
    versioning_configuration {
      status = "Enabled"
    }  
}

#enable server side encryption 
resource "aws_s3_bucket_server_side_encryption_configuration" "server_side_encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

#Explicitly block all public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "public_access" {

  bucket = aws_s3_bucket.terraform_state.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
  
}

resource "aws_dynamodb_table" "terraform_locks" {

  name = "terraform-up-and-running-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  } 
}



