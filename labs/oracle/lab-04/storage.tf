# Source from https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/objectstorage_bucket


resource "oci_objectstorage_bucket" "himkum_bucket_2" {
    #Required
    compartment_id = var.compartment_ocid
    name = "himkum_bucket_2"
    namespace = data.oci_objectstorage_namespace.ns.namespace
}