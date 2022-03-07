# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "tags" {
  description = "The tags to add to the EC2 instance"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
  }
}
