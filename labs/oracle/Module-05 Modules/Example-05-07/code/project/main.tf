
# Example 5-6

module "VM" {
    source = "../modules/EC2"
    ami_type = var.machine_ami
    inst_type = var.machine_type
    VM_name = var.machine_name
    sg_groups = module.SG.secgps
  }

module "SG" {
  source = "../modules/SGroup"
  access_port = 8080
  sg_name = "My Demo"
}

output "s" {
  
  value = module.SG.secgps
}
