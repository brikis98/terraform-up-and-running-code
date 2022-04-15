
output "AMI" {
    description = "The Ubuntu AMI"
    value = data.aws_ami.ubuntu.id
}





