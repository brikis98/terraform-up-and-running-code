variable "aws_region" {
  description = "AWS Region to work with"
  type = string
  default = "eu-west-1"
}

variable "ami_ubuntu_21_04" {
  description = "AMI for Ubuntu 21.04"
  type = string
  default = "ami-00622de605b25a7d6"
  # Ubuntu 21.04 amd64
}
