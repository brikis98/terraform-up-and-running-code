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

# Create a KMS Customer Managed Key (CMK)
resource "aws_kms_key" "cmk" {
  policy = data.aws_iam_policy_document.cmk_admin_policy.json

  # We set a short deletion window, as these keys are only used
  # for testing/learning, and we want to minimize the AWS charges
  deletion_window_in_days = 7
}

# A simple policy that makes the current IAM user the admin
# of the CMK
data "aws_iam_policy_document" "cmk_admin_policy" {
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions   = ["kms:*"]
    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.self.arn]
    }
  }
}

# Look up the details of the current user
data "aws_caller_identity" "self" {}

# Create an alias for the CMK
resource "aws_kms_alias" "cmk" {
  name          = "alias/${var.alias}"
  target_key_id = aws_kms_key.cmk.id
}
