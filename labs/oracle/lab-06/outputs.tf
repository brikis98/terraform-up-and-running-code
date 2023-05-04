
output "Instance_type" {
    description = "instance type used in myVM"
    value = "Hi, I am a ${oci_core_instance.myVM.display_name} instance name"
}