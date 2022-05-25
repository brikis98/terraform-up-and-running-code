variable "server_port" {

    description = "Port used by the webserver"
    type = number
    default = 8080
  
}
variable "instance_security_group_name" {
    description = "Name of the instance security group applied to the Launch config"
    type = string
    default = "ec2-instance-sg"
  
}

variable "alb_security_group_name" {
    description = "Name of the ALB security group name"
    type = string
    default = "alb-sg"
  
}
