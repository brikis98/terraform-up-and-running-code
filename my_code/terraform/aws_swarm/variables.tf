variable "aws_region" {
  description = "AWS Region to work with"
  type        = string
  default     = "eu-west-1"
}

variable "web_port" {
  description = "Port used by the web server"
  type        = number
  default     = 8090
}

variable "ami_ubuntu_21_04" {
  description = "AMI for Ubuntu 21.04"
  type        = string
  # Ubuntu 21.04 amd64
  default = "ami-00622de605b25a7d6"
}
