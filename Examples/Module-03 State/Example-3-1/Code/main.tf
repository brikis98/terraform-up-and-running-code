
# Example 03-01  

resource "aws_instance" "X" {
    ami = "ami-077e31c4939f6a2f3"
    instance_type = "t2.micro"
    tags = {
        Name = "Instance X"
    }
}

resource "aws_instance" "Y" {
    ami = "ami-077e31c4939f6a2f3"
    instance_type = "t2.micro"
    tags = {
        Name = "Instance Y"
    }
}






