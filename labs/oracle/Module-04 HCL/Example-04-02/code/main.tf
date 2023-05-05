resource "oci_objectstorage_bucket" "Matrix" {

    count = length(var.bucket_names)

    #Required
    compartment_id = "ocid1.tenancy.oc1..aaaaaaaa6ag77lnluy7avrzhjkg7g3kriz5t5u2jnsw43yecx4oylzxsv5uq"
    name = "himkum_bucket_${var.bucket_names[count.index]}"
    namespace = "lrsivuswtz6j"
}


variable "bucket_names" {
    type = list(string)
    default = ["Neo",  "Morpheus"]
}

output  "Neo" {
    value = oci_objectstorage_bucket.Matrix[0].name
    description = "Outputs a single string"
}
output  "Everyone" {
    value = oci_objectstorage_bucket.Matrix[*].name
    description = "Outputs a list of strings"
}






