# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "alias" {
  description = "The alias to use for the CMK"
  type        = string
  default     = "kms-cmk-example"
}
