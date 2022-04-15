
# Example 03-02 

resource "aws_instance" "VM" {
    ami = "ami-077e31c4939f6a2f3"
    instance_type = "t2.micro"
    tags = {
        Name = "Default"
    }
}






