output "user_arns" {
  value       = module.users[*].user_arn
  description = "The ARNs of the created IAM users"
}
