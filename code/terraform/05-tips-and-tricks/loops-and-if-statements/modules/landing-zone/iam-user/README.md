# IAM user example

This folder contains an example [Terraform](https://www.terraform.io/) module to create an
[IAM](https://aws.amazon.com/iam/) user in an [Amazon Web Services (AWS) account](http://aws.amazon.com/).

For more info, please see Chapter 5, "Terraform Tips & Tricks: Loops, If-Statements, Deployment, and Gotchas", of
*[Terraform: Up and Running](http://www.terraformupandrunning.com)*.

## Quick start

Terraform modules are not meant to be deployed directly. Instead, you should be including them in other Terraform
configurations. See [live/global/three-iam-users-module-count](../../../live/global/three-iam-users-module-count) and
[live/global/three-iam-users-module-for-each](../../../live/global/three-iam-users-module-for-each) for examples.