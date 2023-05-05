resource "oci_objectstorage_bucket" "Matrix" {

    for_each = toset(var.bucket_names)

    #Required
    compartment_id = "ocid1.tenancy.oc1..aaaaaaaa6ag77lnluy7avrzhjkg7g3kriz5t5u2jnsw43yecx4oylzxsv5uq"
    name = "himkum_bucket_${each.value}"
    namespace = "lrsivuswtz6j"
}


variable "bucket_names" {
    type = list(string)
    default = ["Neo",  "Morpheus"]
}




