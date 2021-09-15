//output "public_ip" {
//  description = "The public IP address of the web server"
//  value = aws_instance.example.public_ip
//}

output "public_port" {
  value = var.web_port
}

output "alb_dns_name" {
  value = aws_lb.example.dns_name
  description = "The domain name of the load balancer"
}
