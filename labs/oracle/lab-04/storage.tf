# Source from https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/objectstorage_bucket

resource "oci_objectstorage_bucket" "test_bucket" {
    #Required
    compartment_id = "ocid1.compartment.oc1..aaaaaaaayf3gksj2b37farc2tep72goofuc25tzsd72blhdjmel54kwv2xla"
    name = "himkum_bucket_2"
    namespace = "lrsivuswtz6j"
}