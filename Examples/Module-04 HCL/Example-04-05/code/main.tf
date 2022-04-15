
# Example 04-05

locals {  
  rules = [{
    description = "HTTP Port",
    port = 80,
    cidr_blocks = ["0.0.0.0/0"],
  },{
    description = "Custom Port",
    port = 81,
    cidr_blocks = ["10.0.0.0/16"],
  }]
}

resource "aws_security_group" "for_each" {
  name        = "Dynamic"
  description = "Dynamic Inline Block"

  dynamic "ingress" {
    for_each = local.rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
    tags = {
      Name = "Dynamic"
    }
 
  }
  





