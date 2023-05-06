resource "oci_core_instance" "ubuntu_instance" {
    # Required
    availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
    compartment_id = "ocid1.compartment.oc1..aaaaaaaayf3gksj2b37farc2tep72goofuc25tzsd72blhdjmel54kwv2xla"
    shape = "VM.Standard2.1"
    source_details {
        source_id = "ocid1.image.oc1.uk-london-1.aaaaaaaa3lb354447utq7gq6v3hqvo7u3nrkbf5fxmdxfem5jq4ngy4rtxba"
        source_type = "image"
    }

    # Optional
    display_name = "himkum-ubuntu"
    create_vnic_details {
        assign_public_ip = true
        subnet_id = "ocid1.subnet.oc1.uk-london-1.aaaaaaaa6n3zzrw6xnv2capcbpxwht4zr72uoxnnxvbrp5vcqmg56p7zaszq"
    }
     
    preserve_boot_volume = false
}