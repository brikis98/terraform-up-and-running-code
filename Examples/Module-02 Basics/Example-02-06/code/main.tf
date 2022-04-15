
# Example 02-06

locals {
    name = file("name.txt")
   
}

resource "aws_instance" "myVM" {
    ami = var.ami_type
    instance_type = var.inst_type
    tags = {
        Name = local.name 
    }
}
