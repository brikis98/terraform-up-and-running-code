resource "aws_instance" "hello_app" {

   ami = data.aws_ami.ubuntu.id
   instance_type = var.instance_type


    user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

    tags = {
       Name = "${var.app_name} App"
    }
    vpc_security_group_ids = [data.aws_security_group.default.id]
  
}

output "my_instance" {
   value = aws_instance.hello_app
}