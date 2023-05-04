data "oci_core_instances" "r1" {
  #Required
  compartment_id = "ocid1.tenancy.oc1..aaaaaaaa6ag77lnluy7avrzhjkg7g3kriz5t5u2jnsw43yecx4oylzxsv5uq"

  filter {
    name = "source_details.source_type"
    values = ["image"]
  }

  filter {
    name = "defined_tags.Operations.CostCenter"
    values = ["42"]
  }

  filter {
    name = "availability_domain"
    values = ["\\w*-AD-1"]
    regex = true
  }

  filter {
    name = "state"
    values = ["RUNNING"]
  }

}