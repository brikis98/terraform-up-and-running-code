
# Example 02-09

resource "oci_core_instances" "Ohio" {
    # Required
    availability_domain = "<region_1_availability_domain>"
    compartment_id = "<region_1_compartment_id>"
    shape = "<shape_of_instance>"
    
    # Optional
    display_name = "him_myVM_1"

    source_details {
        source_id = "<region_1_image_ocid>"
        source_type = "image"
    } 

    create_vnic_details {
        assign_public_ip = true
        subnet_id = "<region_1_public_subnet_id>"
    }
     
    preserve_boot_volume = false 
}

resource "oci_core_instances" "California" {
    provider = oci.region2
    # Required
    availability_domain = "<region_2_availability_domain>"
    compartment_id = "<region_2_compartment_id>"
    shape = "<shape_of_instance>"
    
    # Optional
    display_name = "him_myVM_2"

    source_details {
        source_id = "<region_2_image_ocid>"
        source_type = "image"
    } 

    create_vnic_details {
        assign_public_ip = true
        subnet_id = "<region_2_public_subnet_id>"
    }
     
    preserve_boot_volume = false
}



