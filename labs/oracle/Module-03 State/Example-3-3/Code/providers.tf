terraform {
  backend "http" {
    address = "https://objectstorage.uk-london-1.oraclecloud.com/p/J1Z9AB_-KZ8nQOEOtYZfcT6NgoI7-NVO-Jejauuuvf5dshUv8kXfOflN1l8uf6dt/n/lrsivuswtz6j/b/himkum_bucket_500/o/terraform.tfstate"
    update_method = "PUT"
  }
}

provider "oci" {
  tenancy_ocid = "<tenancy_ocid>"
  user_ocid = "<user_ocid>" 
  private_key_path = "<rsa-private-key-path>"
  fingerprint = "<fingerprint>"
}  

