# Examples Notes

These notes document how I work with the examples in the terraform class.

## Module 3

There is not a lot of code writing in module 3; instead, there is a lot of manipulating a set of EC2 instances to illustrate how they are maintained in the state file

The basic code used is in the example 3-1 folder

### Example 3-1

This example is used to provide practical demos of the comments made about state. The configuration is simple - just two VMS.  What I demo in this example is the same as what the students will do in the lab, so they get to see it before they try it.

I would suggest having a running VM created at the console to show that all of the terraform operations do not affect non-terraform resources

The specific things I demonstrate are:

1. Commenting out a VM resource and show that terraform deletes the running vm
2. The state list and show commands
3. Making a change in the running VM, usually the Name, then showing how terraform reverts the running VM to conform to the specification
3. Making a non-destructive change in the code to a VM, usually changing the instance type and showing how terraform does a change in place
4. Making a destructive chance, like the ami from amazon linux to ubuntu, to show how the resource is recreated
5. Using the state rm command to remove a VM from terraform, showing that it is still running in AWS and terraform can no longer see it and will try and create a new version
6. Using the import command to add the removed vm back into terraform
7. Create a copy of one of the instance definitions but with a different name then use the state mv command to rename one of the instances to the new name. Since the old name is no longer associated with the running instance, terraform will plan to create one
8. Finally, the use of the taint and untaint commands are shown

### Example 3-2

This example is a preview of lab 3-2 demonstrating the use of workspaces. I use very simple code with just a single VM

1. The VM is tagged with the Name "default"
2. Run apply to create the VM
3. Show the state file in the root directory and the running VM in the console
4. Create workspace "dev" and switch to it
5. Retag the VM with the name "dev"
6. Run terraform apply and show there are two VMs, one named "default" and one named "dev"
7. Show the workspace state files that have been created
8. Switch back to the default workspace and run terraform plan to show that the default VM will be altered in place and that this is not what we want
9. Try to delete the "dev" workspace and notice the terraform warning
10. Switch to dev and run destroy
11. switch back to default and run destroy


I end this demo by underscoring that there are two different things that have to be managed
* The state files, which terraform manages
* The source code *tf file that we manage

The takeaway that leads onto the next example is that with sloppy source code management, we can corrupt our state

### Example 3-3

This example requires that you have git installed.

1. Using the same code from the previous example, make sure the VM is named "default"
2. Create a git repo, add main.tf to the repo and commit.  The default workspace is now using the main git branch
3. Run terraform apply   
4. Switch to the "dev" workspace
5. Create and checkout a branch called "dev"
6. Rename the instance to "dev" and run terraform apply
7. Examine both machines in AWS to ensure they are running
8. Switch to the default workspace
9. Checkout the main git branch
10. Run terraform plan to see that code changes on the dev branch will not affect default

This will be the only place where git will be demonstrated.  Point out that the danger of this approach is that forgetting to check out the right branch when you switch workspaces could step on other people's code.

Clean up and destroy all the resources used in this demo

### Example 3-4

Example walks through the setting up of the remote backend





