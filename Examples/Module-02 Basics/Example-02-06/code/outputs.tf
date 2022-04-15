
output "EC2_ami" {
    description = "ami type used in myVM"
    value = aws_instance.myVM.ami
}

output "EC2_type" {
    description = "instance type used in myVM"
    value = "Hi, my name is ${local.name}"
}