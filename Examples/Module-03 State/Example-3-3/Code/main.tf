resource "aws_s3_bucket" "zippy" {
  bucket = "terraform-zippy"

  # Prevent accidental deletion of this S3 bucket
 # lifecycle {
 #   prevent_destroy = true
 # }

  # Enable versioning so we can see the full revision history of our
  # state files
  versioning {
    enabled = false
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

resource "aws_dynamodb_table" "state-locks" {
  name         = "zippy-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}


output "s3_bucket_arn" {
  value       = aws_s3_bucket.zippy.arn
  description = "The ARN of the S3 bucket"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.state-locks.name
  description = "The name of the DynamoDB table"
}
