
# Example 04-01  

resource "aws_instance" "Clone" {
    count = 3
    ami = "ami-077e31c4939f6a2f3"
    instance_type = "t2.micro"
    tags = {
        Name = "VM-${count.index}"
    }
}






