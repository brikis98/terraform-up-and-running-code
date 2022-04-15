
# Example 02-04

locals {
    name = "example 04"
}

resource "aws_instance" "myVM" {
    ami = var.ami_type
    instance_type = var.inst_type
    tags = {
        Name = local.name 
    }
}