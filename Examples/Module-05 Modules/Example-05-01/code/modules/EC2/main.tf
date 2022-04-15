
# In the EC2 Module

resource "aws_instance" "alpha" {
    ami = "ami-00399ec92321828f5"
    instance_type = "t2.micro"
    tags = {
        source = "EC2 Module"
    }
}    

