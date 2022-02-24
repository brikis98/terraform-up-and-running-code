output "instance_id" {
  value       = aws_instance.example.id
  description = "The ID of the EC2 instance"
}

output "instance_ip" {
  value       = aws_instance.example.public_ip
  description = "The public IP of the EC2 instance"
}

output "iam_role_arn" {
  value       = aws_iam_role.instance.arn
  description = "The ARN of the IAM role"
}

