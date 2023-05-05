
output "secgps" {
    value =aws_security_group.app_port.id
    description = "Returns the id of the security group"
}