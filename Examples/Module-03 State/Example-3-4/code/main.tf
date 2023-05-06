


resource "aws_instance" "myVM" {
    ami = "ami-077e31c4939f6a2f3"
    instance_type = "t2.micro"
    tags = {
        Name = "Remote Backend"
    }
}
