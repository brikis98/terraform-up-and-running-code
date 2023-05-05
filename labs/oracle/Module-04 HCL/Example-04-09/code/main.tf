variable "make_bucket" {
  type = bool
}

resource "oci_objectstorage_bucket" "test_bucket" {

    count = var.make_bucket ? 1 : 0

    #Required
    compartment_id = "ocid1.tenancy.oc1..aaaaaaaa6ag77lnluy7avrzhjkg7g3kriz5t5u2jnsw43yecx4oylzxsv5uq"
    name = "himkum_bucket_conditional"
    namespace = "lrsivuswtz6j"
}