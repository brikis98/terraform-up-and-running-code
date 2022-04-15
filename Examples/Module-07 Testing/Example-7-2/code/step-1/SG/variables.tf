
variable "access_port" {
    description = "Access port to use for the application"
    type = number
    default = 80
}

variable "sg_name" {
    description = "The name of the security group"
    type = string
    default = "My SG"
}

