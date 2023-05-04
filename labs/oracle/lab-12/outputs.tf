
output "Instance_type" {
    description = "instance type used in myVM"
    value = oci_core_instance.myVM.display_name
}