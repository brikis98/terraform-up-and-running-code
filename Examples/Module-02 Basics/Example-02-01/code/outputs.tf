
output "EC2_public_ip" {
    description = "Public IP address of 'myVM"
    value = aws_instance.myVM.public_ip 
}

output "VPC_id" {
    value = data.aws_vpc.default_VPC.id
}