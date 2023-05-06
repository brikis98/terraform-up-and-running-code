provider "aws" {
  version = "~> 2.0"
  region = "us-west-2"
}

provider "aws" {
  alias  = "california"
  region = "us-west-1"
}

resource "aws_s3_bucket" "student_buckets" {
  count         = length(var.students)
  bucket        = "rockholla-di-${var.students[count.index].name}"
  acl           = "private"
  provider      = aws.california
  force_destroy = true
}

resource "aws_iam_account_password_policy" "students" {
  minimum_password_length        = 8
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = false
  allow_users_to_change_password = true
}

resource "aws_iam_user" "students" {
  count         = length(var.students)
  name          = var.students[count.index].name
  force_destroy = true
}

resource "aws_iam_user_login_profile" "students" {
  count                   = length(var.students)
  user                    = var.students[count.index].name
  password_length         = 10
  pgp_key                 = var.pgp_key
  password_reset_required = false
  lifecycle {
    ignore_changes = [password_length, password_reset_required, pgp_key]
  }
  depends_on = [aws_iam_user.students]
}

resource "aws_iam_policy" "student_bucket_access" {
  count         = length(var.students)
  name          = "${var.students[count.index].name}StudentBucketAccess"
  description   = "Allowing student access to their own bucket"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowBase",
            "Effect": "Allow",
            "Action": [
                "s3:ListAllMyBuckets",
                "s3:GetBucketLocation"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowListMyBucket",
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::rockholla-di-${var.students[count.index].name}",
                "arn:aws:s3:::rockholla-di-${var.students[count.index].name}-*"
            ]
        },
        {
            "Sid": "AllowAllInMyBucket",
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
              "arn:aws:s3:::rockholla-di-${var.students[count.index].name}/*",
              "arn:aws:s3:::rockholla-di-${var.students[count.index].name}-*/*"
            ]
        }
    ]
}
EOF

  depends_on = [aws_iam_user.students]
}

resource "aws_iam_policy" "student_ec2_access" {
  name          = "StudentEC2Access"
  description   = "Allowing student access to EC2 accordingly"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowAllOnEC2",
            "Action": "ec2:*",
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Sid": "OnlyAllowCertainInstanceTypesToBeCreated",
            "Effect": "Deny",
            "Action": [
                "ec2:RunInstances"
            ],
            "Resource": "arn:aws:ec2:*:*:instance/*",
            "Condition": {
                "ForAnyValue:StringNotLike": {
                    "ec2:InstanceType": [
                        "*.nano",
                        "*.small",
                        "*.micro",
                        "*.medium"
                    ]
                }
            }
        },
        {
            "Sid": "AllowAllELB",
            "Effect": "Allow",
            "Action": "elasticloadbalancing:*",
            "Resource": "*"
        },
        {
            "Sid": "AllowAllAutoscaling",
            "Effect": "Allow",
            "Action": "autoscaling:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:CreateServiceLinkedRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:AWSServiceName": [
                        "autoscaling.amazonaws.com",
                        "ec2scheduled.amazonaws.com",
                        "elasticloadbalancing.amazonaws.com",
                        "spot.amazonaws.com",
                        "spotfleet.amazonaws.com",
                        "transitgateway.amazonaws.com"
                    ]
                }
            }
        }
    ]
}
EOF
}

resource "aws_iam_policy" "student_credentials_access" {
  name          = "StudentIAMCredentialsAccess"
  description   = "Allowing student to rotate and manage their own credentials"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:ListUsers",
                "iam:GetAccountPasswordPolicy"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:*AccessKey*",
                "iam:ChangePassword",
                "iam:GetUser",
                "iam:*ServiceSpecificCredential*",
                "iam:*SigningCertificate*"
            ],
            "Resource": ["arn:aws:iam::*:user/$${aws:username}"]
        }
    ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "student_bucket_access" {
  count       = length(var.students)
  user        = var.students[count.index].name
  policy_arn  = aws_iam_policy.student_bucket_access.*.arn[count.index]
  depends_on  = [aws_iam_user.students]
}

resource "aws_iam_user_policy_attachment" "student_ec2_access" {
  count       = length(var.students)
  user        = var.students[count.index].name
  policy_arn  = aws_iam_policy.student_ec2_access.arn
  depends_on  = [aws_iam_user.students]
}

resource "aws_iam_user_policy_attachment" "student_credentials_access" {
  count       = length(var.students)
  user        = var.students[count.index].name
  policy_arn  = aws_iam_policy.student_credentials_access.arn
  depends_on  = [aws_iam_user.students]
}

resource "aws_iam_user_policy_attachment" "cloud9_user_access" {
  count       = length(var.students)
  user        = var.students[count.index].name
  policy_arn  = "arn:aws:iam::aws:policy/AWSCloud9User"
  depends_on  = [aws_iam_user.students]
}

resource "aws_iam_user_policy_attachment" "dynamodb_user_access" {
  count       = length(var.students)
  user        = var.students[count.index].name
  policy_arn  = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  depends_on  = [aws_iam_user.students]
}
