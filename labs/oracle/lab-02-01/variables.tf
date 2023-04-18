# data from terraform.tfvars file

variable "tenancy_ocid" {}
variable "compartment_ocid" {}

# Choose an Avalability Domain
variable "AD" {
    default = "1"
}