# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "db_name" {
  description = "The name to use for the database. Required unless replicate_source_db is set."
  type        = string
  default     = null
}

variable "db_username" {
  description = "The username for the database. Required unless replicate_source_db is set."
  type        = string
  sensitive   = true
  default     = null
}

variable "db_password" {
  description = "The password for the database. Required unless replicate_source_db is set."
  type        = string
  sensitive   = true
  default     = null
}

variable "backup_retention_period" {
  description = "Days to retain backups. Must be set to a positive integer to enable replication."
  type        = number
  default     = null
}

variable "replicate_source_db" {
  description = "If specified replicate the RDS database at the given ARN."
  type        = string
  default     = null
}

