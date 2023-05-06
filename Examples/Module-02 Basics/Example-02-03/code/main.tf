
# Example 02-03

resource "aws_instance" "myVM" {
    ami = var.ami_type
    instance_type = var.inst_type
    tags = {
        Name = "Example-03"
    }
}