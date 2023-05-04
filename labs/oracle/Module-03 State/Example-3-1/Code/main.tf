resource "oci_core_instance" "X" {
    # Required
    availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
    compartment_id = "ocid1.tenancy.oc1..aaaaaaaa6ag77lnluy7avrzhjkg7g3kriz5t5u2jnsw43yecx4oylzxsv5uq"
    shape = "VM.Standard2.1"
    source_details {
        source_id = "ocid1.image.oc1.uk-london-1.aaaaaaaa3lb354447utq7gq6v3hqvo7u3nrkbf5fxmdxfem5jq4ngy4rtxba"
        source_type = "image"
    }

    # Optional
    display_name = "Instance_X"
    create_vnic_details {
        assign_public_ip = true
        subnet_id = "ocid1.subnet.oc1.uk-london-1.aaaaaaaa6n3zzrw6xnv2capcbpxwht4zr72uoxnnxvbrp5vcqmg56p7zaszq"
    }
     
    preserve_boot_volume = false
}

resource "oci_core_instance" "Y" {
    # Required
    availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
    compartment_id = "ocid1.tenancy.oc1..aaaaaaaa6ag77lnluy7avrzhjkg7g3kriz5t5u2jnsw43yecx4oylzxsv5uq"
    shape = "VM.Standard2.1"
    source_details {
        source_id = "ocid1.image.oc1.uk-london-1.aaaaaaaa3lb354447utq7gq6v3hqvo7u3nrkbf5fxmdxfem5jq4ngy4rtxba"
        source_type = "image"
    }

    # Optional
    display_name = "Instance_Y"
    create_vnic_details {
        assign_public_ip = true
        subnet_id = "ocid1.subnet.oc1.uk-london-1.aaaaaaaa6n3zzrw6xnv2capcbpxwht4zr72uoxnnxvbrp5vcqmg56p7zaszq"
    }
     
    preserve_boot_volume = false
}

output "name-of-first-availability-domain" {
  value = data.oci_identity_availability_domains.ads.availability_domains[0].name
}




