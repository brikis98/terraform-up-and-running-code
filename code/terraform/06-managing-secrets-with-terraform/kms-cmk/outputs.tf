output "cmk_arn" {
  value       = aws_kms_key.cmk.arn
  description = "The ARN of the CMK"
}

output "cmk_alias" {
  value       = aws_kms_alias.cmk.name
  description = "The alias of the CMK"
}