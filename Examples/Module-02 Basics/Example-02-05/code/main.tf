
# Example 02-05


locals {

    message = <<-MYSRT
    this is a multi line string
    that goes on and one and on
    MYSRT
    
    name = "Example 2-5"    
}


resource "aws_instance" "myVM" {
    ami = var.ami_type
    instance_type = var.inst_type
    tags = {
        Name = local.name
         
    }
}
