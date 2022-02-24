# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "The name to use for the EKS cluster and all resources in this module"
  type        = string
}

variable "min_size" {
  description = "Minimum number of nodes to have in the EKS cluster"
  type        = number
}

variable "max_size" {
  description = "Maximum number of nodes to have in the EKS cluster"
  type        = number
}

variable "desired_size" {
  description = "Desired number of nodes to have in the EKS cluster"
  type        = number
}

variable "instance_types" {
  description = "The types of EC2 instances to run in the node group (e.g., t2.micro)."
  type        = list(string)
}
