# Moved example

This folder contains example [Terraform](https://www.terraform.io/) configuration that shows how to use `moved` blocks
for refactoring.

For more info, please see Chapter 5, "Terraform Tips & Tricks: Loops, If-Statements, Deployment, and Gotchas", of
*[Terraform: Up and Running](http://www.terraformupandrunning.com)*.

## Pre-requisites

* You must have [Terraform](https://www.terraform.io/) installed on your computer.
* You must have an [Amazon Web Services (AWS) account](http://aws.amazon.com/).
* You must deploy the MySQL database in [data-stores/mysql](../../data-stores/mysql) BEFORE deploying the
  configuration in this folder.

Please note that this code was written for Terraform 1.x.

## Quick start

**Please note that this example will deploy real resources into your AWS account. We have made every effort to ensure
all the resources qualify for the [AWS Free Tier](https://aws.amazon.com/free/), but we are not responsible for any
charges you may incur.**

Configure your [AWS access
keys](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) as
environment variables:

```
export AWS_ACCESS_KEY_ID=(your access key id)
export AWS_SECRET_ACCESS_KEY=(your secret access key)
```

The idea of this example is to show how you can use `moved` blocks to handle code refactoring, so part of running this
example is updating the code:

1. Uncomment the old `aws_security_group` resource called `instance`.
2. Comment out the new `aws_security_group` resource called `cluster_instance`.
3. Comment out the `moved` block.
4. Run `apply` to create the Security Group with the old name.
5. Comment out the old `aws_security_group` resource called `instance`.
6. Uncomment the new `aws_security_group` resource called `cluster_instance`.
7. Uncomment the `moved` block.
8. Run `apply` and the state should be automatically updated, with no changes to the Security Group.
9. Run `destroy` when you're done.
