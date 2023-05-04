provider "oci" {
  alias            = "home"
  region           = "<region_1>"
  tenancy_ocid     = "<region_1_tenancy_ocid>"
  user_ocid        = "<region_1_user_ocid>"
  fingerprint      = "<region_1_fingerprint>"
  private_key_path = "<region_1_private_key_path>"
}

provider "oci" {
  alias            = "region2"
  region           = "<region_2>"
  tenancy_ocid     = "<region_2_tenancy_ocid>"
  user_ocid        = "<region_2_user_ocid>"
  fingerprint      = "<region_2_fingerprint>"
  private_key_path = "<region_2_private_key_path>"
}
