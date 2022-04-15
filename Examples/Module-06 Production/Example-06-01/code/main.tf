 
# Example 6-1 

resource "aws_instance" "example" {
    ami           = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"

    provisioner "local-exec" {
         command = "echo \"Hello, World from $(uname -smp)\""
        }
    }