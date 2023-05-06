
variable "instance_type" {
   description = "The instance type to use"
    type = string
}


variable "access_port" {
    description = "Access port to use for the application"
    type = number
    default = 80
}

variable "app_name" {
    description = "The name of the application deployment"
    type = string
}

