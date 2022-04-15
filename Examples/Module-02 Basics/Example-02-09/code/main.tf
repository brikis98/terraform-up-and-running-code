
# Example 02-09

resource "aws_instance" "Ohio" {
    ami = "ami-00399ec92321828f5"
    instance_type = "t2.micro"
    tags = {
        Name = "us-east-2"
    }
}

resource "aws_instance" "Virginia" {
    provider = aws.Virginia
    ami = "ami-09e67e426f25ce0d7"
    instance_type = "t2.micro"
    tags = {
        Name = "us-east-1"
    }
}



