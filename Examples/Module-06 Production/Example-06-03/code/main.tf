 
# Example 6-3

 resource "null_resource" "example" {
    # Use UUID to force this null_resource to be recreated on every
     # call to 'terraform apply'
    triggers = {
        uuid = uuid()
    }

    provisioner "local-exec" {
        command = "echo \"Hello, World from $(uname -smp)\""
    }
}
