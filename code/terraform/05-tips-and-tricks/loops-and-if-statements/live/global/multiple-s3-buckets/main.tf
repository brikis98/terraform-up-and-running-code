terraform {
  required_version = ">= 0.12, < 0.13"
}

provider "aws" {
  region = "us-east-2"

  # Allow any 2.x version of the AWS provider
  version = "~> 2.0"
}

variable "bucket_names" {
  description = "Create S3 buckets with these names"
  type        = list(string)
}

resource "aws_s3_bucket" "example" {
  count  = length(var.bucket_names)
  bucket = var.bucket_names[count.index]
}

output "bucket_names" {
  value = aws_s3_bucket.example[*].bucket
}
