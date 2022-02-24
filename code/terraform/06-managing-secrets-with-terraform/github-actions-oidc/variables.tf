# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "allowed_repos_branches" {
  description = "The GitHub repos and branches that should be allowed to assume the IAM role."
  type        = list(object({
    org    = string
    repo   = string
    branch = string
  }))
  # Example:
  # default = [
  #   {
  #     org    = "brikis98"
  #     repo   = "terraform-up-and-running-code"
  #     branch = "main"
  #   }
  # ]
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "The name used to namespace all the resources created by this module"
  type        = string
  default     = "github-actions-oidc-example"
}

