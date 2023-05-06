output "Instance_type" {
    description = "instance type used in myVM"
    value = "Hi, I am a ${oci_core_instance.myVM.display_name} instance name"
}

output "Message" {
    value = local.message
}

output "Port" {
    description = "Experiment with a number variable"
    value = var.port
}