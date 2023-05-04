variable compartment_id {
    description = "compartment id"
    type = string
    default = "ocid1.tenancy.oc1..aaaaaaaa6ag77lnluy7avrzhjkg7g3kriz5t5u2jnsw43yecx4oylzxsv5uq"
    
}

variable shape {
    description = "instance type"
    type = string
}

variable "virtual_machines" {
  type = map(object({}))

  default = {
    test_vm_1 = {}
    test_vm_2 = {}
  }
}
