
# Example 04-09


variable "make_VM" {
  type = bool
}

resource "aws_instance" "VM" {
    count = var.make_VM ? 1 : 0
    ami = "ami-077e31c4939f6a2f3"
    instance_type = "t2.micro"
    tags = {
        Name = "Conditional"
    }
}


