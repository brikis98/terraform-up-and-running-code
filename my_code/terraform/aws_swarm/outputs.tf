output "public_ip" {
  description = "The public IP address of the swam node"
  value       = aws_instance.swarm-node.public_ip
}

output "public_port" {
  value = var.web_port
}
