

module "VM-1" {
    source = "../modules/EC2"
    ami_type = var.machine_amis[0]
    inst_type = var.machine_types[0]
    VM_name = var.machine_names[0]
  }

