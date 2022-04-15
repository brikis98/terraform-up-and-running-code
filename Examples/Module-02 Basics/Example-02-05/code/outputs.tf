
output "EC2_ami" {
    description = "ami type used in myVM"
    value = aws_instance.myVM.ami
}

output "EC2_type" {
    description = "instance type used in myVM"
    value = "Hi, I am a ${aws_instance.myVM.instance_type} instance type"
}

output "Message" {
    value = local.message
}
 