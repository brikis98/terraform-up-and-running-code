terraform {
  backend "http" {
    address = "https://objectstorage.uk-london-1.oraclecloud.com/https://objectstorage.uk-london-1.oraclecloud.com/p/QXH8R8I1Mr_4vsvP2_6ePSrRYqtAO-e1LEyzOEhhPW5TqcnCBqAgUG3onGnjk6UB/n/lrsivuswtz6j/b/himkum_bucket_500/o/"
    update_method = "PUT"
  }
}

provider "oci" {
  tenancy_ocid = "<tenancy_ocid>"
  user_ocid = "<user_ocid>" 
  private_key_path = "<rsa-private-key-path>"
  fingerprint = "<fingerprint>"
}  

