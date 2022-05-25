output "alb_dns_name" {
    value = aws_lb.billi_web_lb.dns_name
    description = "DNS name of the LB"
}