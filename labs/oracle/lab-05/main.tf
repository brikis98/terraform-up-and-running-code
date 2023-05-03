resource "oci_core_instance" "myVM" {
    # Required
    availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
    compartment_id = var.compartment_id
    shape = var.shape
    
    # Optional
    display_name = "him_myVM"
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}