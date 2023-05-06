
# Example 02-01

resource "aws_instance" "myVM" {
    ami = "ami-077e31c4939f6a2f3"
    instance_type = "t2.micro"
    tags = {
        Name = "Example-01"
    }
}

resource "aws_s3_bucket" "myBucket" {
    bucket = "terraform-example-02-01"
}

data "aws_vpc" "default_VPC" {
    default = true
}