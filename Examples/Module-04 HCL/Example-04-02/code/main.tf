
# Example 04-02 

resource "aws_instance" "Matrix" {
    count = length(var.VM_names)
    ami = "ami-077e31c4939f6a2f3"
    instance_type = "t2.micro"
    tags = {
        Name = "VM-${var.VM_names[count.index]}"
    }
}

variable "VM_names" {
    type = list(string)
    default = ["Neo",  "Morpheus"]
}

output  "Neo" {
    value = aws_instance.Matrix[0].tags.Name
    description = "Outputs a single string"
}
output  "Everyone" {
    value = aws_instance.Matrix[*].tags.Name
    description = "Outputs a list of strings"
}






