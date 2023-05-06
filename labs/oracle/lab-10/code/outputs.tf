output "OCI_instances" {
    description = "The OCI instances"
    value = data.oci_core_instances.r1.id
}