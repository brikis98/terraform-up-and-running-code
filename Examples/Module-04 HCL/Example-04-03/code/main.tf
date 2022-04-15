
# Example 04-03 

resource "aws_instance" "Matrix" {
    for_each = toset(var.VM_names)
    ami = "ami-077e31c4939f6a2f3"
    instance_type = "t2.micro"
    tags = {
        Name = "VM-${each.value}"
    }
}

variable "VM_names" {
    type = list(string)
    default = ["Neo",  "Morpheus"]
} 





