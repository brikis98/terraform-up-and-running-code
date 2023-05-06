
# Example 04-06

 variable "names" {
    description = "A list of names"
    type        = list(string)
    default     = ["neo", "trinity", "morpheus"]
  }

  output "upper_names" {
     value = [for name in var.names : upper(name)]
  } 

  output "short_upper_names" {
    value = [for name in var.names : upper(name) if length(name) < 5]
  } 



