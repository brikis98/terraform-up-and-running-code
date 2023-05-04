locals {
    developer = "Zippy"
    documentation = templatefile("document.txt", {myname = local.developer})
}

resource "oci_core_instance" "myVM" {
    # Required
    availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
    compartment_id = var.compartment_id
    shape = var.shape
    
    # Optional
    display_name = "${local.developer}'s machine"

    source_details {
        source_id = "ocid1.image.oc1.uk-london-1.aaaaaaaa3lb354447utq7gq6v3hqvo7u3nrkbf5fxmdxfem5jq4ngy4rtxba"
        source_type = "image"
    } 

    create_vnic_details {
        assign_public_ip = true
        subnet_id = "ocid1.subnet.oc1.uk-london-1.aaaaaaaa6n3zzrw6xnv2capcbpxwht4zr72uoxnnxvbrp5vcqmg56p7zaszq"
    }
     
    preserve_boot_volume = false 
}
