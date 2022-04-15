
# Example 04-08

variable "names" {
  description = "Names to render"
  type        = list(string)
  default     = ["neo", "trinity", "morpheus"]
}

output "for_directive" {
  
  value = <<EOF
%{ for name in var.names }
  ${name}
%{ endfor }
EOF
}


output "for_directive_strip_marker" {

  value = <<EOF
%{~ for name in var.names }
  ${name}
%{~ endfor }
EOF
}



