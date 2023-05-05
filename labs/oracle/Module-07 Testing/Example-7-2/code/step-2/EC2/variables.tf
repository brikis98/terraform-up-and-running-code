variable "ami_type" {
    description = "The ami to use depending on region"
    type = string
    default = "ami-03d315ad33b9d49c4"
}

variable "instance_type" {
    description = "The instance class to use"
    type = string
    default = "t2.small"
}

variable "access_port" {
    description = "Access port to use for the application"
    type = number
    default = 80
}

variable "app_name" {
    description = "The name of the application deployment"
    type = string
    default = "No Name"
}

variable "sg_groups" {
    description = "Associated security groups"
    type = list(string)
}
