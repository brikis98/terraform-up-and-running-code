output "aws_iam_github_actions_oidc_arn" {
  value       = aws_iam_openid_connect_provider.github_actions.arn
  description = "The ARN of the IAM OIDC identity provider for GitHub Actions"
}

output "aws_iam_github_actions_oidc_url" {
  value       = aws_iam_openid_connect_provider.github_actions.url
  description = "The URL of the IAM OIDC identity provider for GitHub Actions"
}

output "iam_role_arn" {
  value       = aws_iam_role.instance.arn
  description = "The ARN of the IAM role"
}
