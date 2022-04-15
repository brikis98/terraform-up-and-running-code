# Module Bucket
# Example 7-1

resource "aws_s3_bucket" "b" {
    bucket = local.devname
}

# developer note to self -- remove this local stuff once the code works

locals {
    devname = "devbucket-1234-benny"
}

variable "bname" {
    description = "Bucket name used passed from calling module" 
    type = string
}

## Added to make the bucket module testable

output "bucket-id" {
    value = aws_s3_bucket.b.id
}