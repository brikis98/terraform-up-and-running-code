output "arn" {
  value       = module.mysql.arn
  description = "The ARN of the database"
}

output "address" {
  value       = module.mysql.address
  description = "Connect to the database at this endpoint"
}

output "port" {
  value       = module.mysql.port
  description = "The port the database is listening on"
}
