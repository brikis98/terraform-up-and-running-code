output "public_ip_1" {
  description = "The public IP address of the swam node"
  value       = aws_instance.swarm-node[0].public_ip
}

output "public_ip_2" {
  description = "The public IP address of the swam node"
  value       = aws_instance.swarm-node[1].public_ip
}

output "public_ip_3" {
  description = "The public IP address of the swam node"
  value       = aws_instance.swarm-node[2].public_ip
}

output "public_port" {
  value = var.web_port
}
