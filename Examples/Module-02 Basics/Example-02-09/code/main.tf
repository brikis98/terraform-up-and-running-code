
# Example 02-09

resource "aws_instance" "Ohio" {
    ami = "ami-00399ec92321828f5"
    instance_type = "t2.micro"
    tags = {
        Name = "us-east-2"
    }
}

resource "aws_instance" "California" {
    provider = aws.California
    ami = "ami-0d9858aa3c6322f73"
    instance_type = "t2.micro"
    tags = {
        Name = "us-west-1"
    }
}



