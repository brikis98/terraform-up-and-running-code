# Module Bucket
# Example 7-1

resource "oci_objectstorage_bucket" "test_bucket" {

    #Required
    compartment_id = "ocid1.tenancy.oc1..aaaaaaaa6ag77lnluy7avrzhjkg7g3kriz5t5u2jnsw43yecx4oylzxsv5uq"
    name = local.devname
    namespace = "lrsivuswtz6j"
}

# developer note to self -- remove this local stuff once the code works

locals {
    devname = "devbucket-1234-benny"
}

variable "bname" {
    description = "Bucket name used passed from calling module" 
    type = string
}

## Added to make the bucket module testable

output "bucket-id" {
    value = oci_objectstorage_bucket.b.id
}