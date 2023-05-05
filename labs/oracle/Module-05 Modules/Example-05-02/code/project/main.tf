

module "bucket-1" {
    source = "../modules/bucket"
    compartment_id = "ocid1.tenancy.oc1..aaaaaaaa6ag77lnluy7avrzhjkg7g3kriz5t5u2jnsw43yecx4oylzxsv5uq"
    namespace = "lrsivuswtz6j"
    name = "himkum_bucket_alpha"
  }

module "bucket-2" {
    source = "../modules/bucket"
    compartment_id = "ocid1.tenancy.oc1..aaaaaaaa6ag77lnluy7avrzhjkg7g3kriz5t5u2jnsw43yecx4oylzxsv5uq"
    namespace = "lrsivuswtz6j"
    name = "himkum_bucket_beta"
  }

  