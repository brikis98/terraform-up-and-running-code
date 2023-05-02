resource "oci_core_instance" "ubuntu_instance" {
    # Required
    availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
    compartment_id = "ocid1.tenancy.oc1..aaaaaaaa6ag77lnluy7avrzhjkg7g3kriz5t5u2jnsw43yecx4oylzxsv5uq"
    shape = "VM.Standard2.1"
    source_details {
        source_id = "ocid1.image.oc1.uk-london-1.aaaaaaaabe4bbnwk4r72e6xytexsrranv5v6lkaae3yvudn32p36oul5ch3q"
        source_type = "image"
    }

    # Optional
    display_name = "himkum-ubuntu"
    create_vnic_details {
        assign_public_ip = true
        subnet_id = "ocid1.subnet.oc1.uk-london-1.aaaaaaaa6n3zzrw6xnv2capcbpxwht4zr72uoxnnxvbrp5vcqmg56p7zaszq"
    }
    metadata = {
        ssh_authorized_keys = file("C:/himanshu/Document/Learning/ssh/himanshu-ssh-key.pub")
    } 
    preserve_boot_volume = false
}