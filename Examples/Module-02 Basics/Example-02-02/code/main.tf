
# Example 02-02

resource "aws_instance" "myVM" {
    ami = var.ami_type
    instance_type = var.inst_type
    tags = {
        Name = "Example-02"
    }
}

