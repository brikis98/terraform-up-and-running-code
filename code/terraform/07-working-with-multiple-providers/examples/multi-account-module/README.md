# Multi AWS account example (reusable module)

This folder contains an example [Terraform](https://www.terraform.io/) configuration that shows how to have one
Terraform module authenticate to multiple [Amazon Web Services (AWS) accounts](http://aws.amazon.com/). This works by
having a reusable module that defines two `configuration_aliases` and a root module that passes in two providers to
the reusable module, one of which assumes IAM role in one of those AWS accounts.

For more info, please see Chapter 7, "Working with Multiple Providers", of
*[Terraform: Up and Running](http://www.terraformupandrunning.com)*.

## Pre-requisites

* You must have [Terraform](https://www.terraform.io/) installed on your computer.
* You must have at least two [Amazon Web Services (AWS) accounts](http://aws.amazon.com/).
* You must have an IAM role in one of those AWS accounts that you can assume from the other.

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

Open `variables.tf` and specify the IAM role to assume in the child AWS account using the `child_iam_role_arn` input
variable.

Deploy the code:

```
terraform init
terraform apply
```

Clean up when you're done:

```
terraform destroy
```