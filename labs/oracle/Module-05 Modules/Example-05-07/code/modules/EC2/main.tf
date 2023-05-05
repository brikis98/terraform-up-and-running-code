
# In the EC2 Module

resource "aws_instance" "alpha" {
    ami = var.ami_type
    instance_type = var.inst_type
    tags = {
        source = "EC2 Module"
        Name = var.VM_name
    }
    vpc_security_group_ids = [var.sg_groups]
}    

