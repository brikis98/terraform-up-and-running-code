# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "child_iam_role_arn" {
  description = "The ARN of an IAM role to assume in the child AWS account"
  type        = string
}