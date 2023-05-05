resource "oci_objectstorage_bucket" "test_bucket" {

    #Required
    compartment_id = var.compartment_id
    namespace = var.namespace
    source = "bucket Module"
    name = var.name
}   



