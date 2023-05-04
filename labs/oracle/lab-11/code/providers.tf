provider "oci" {
  tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaa6ag77lnluy7avrzhjkg7g3kriz5t5u2jnsw43yecx4oylzxsv5uq"
}

provider "oci" {
  alias            = "region2"
  tenancy_ocid     = "ocid1.compartment.oc1..aaaaaaaayf3gksj2b37farc2tep72goofuc25tzsd72blhdjmel54kwv2xla"
}
