

module "VM-1" {
    source = "../modules/EC2"
    ami_type = "ami-00399ec92321828f5"
    inst_type = "t2.micro"
    VM_name = "alpha"
  }

module "VM-2" {
    source = "../modules/EC2"
    ami_type = "ami-00399ec92321828f5"
    inst_type = "t2.small"
    VM_name = "beta"
  }

  