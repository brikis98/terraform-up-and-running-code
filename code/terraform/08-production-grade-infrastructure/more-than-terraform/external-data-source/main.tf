terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "~> 2.0"
    }
  }
}

data "external" "echo" {
  program = ["bash", "-c", "cat /dev/stdin"]

  query = {
    foo = "bar"
  }
}

output "echo" {
  value = data.external.echo.result
}

output "echo_foo" {
  value = data.external.echo.result.foo
}
