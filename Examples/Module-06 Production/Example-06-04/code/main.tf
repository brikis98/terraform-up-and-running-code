 
# Example 6-4

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