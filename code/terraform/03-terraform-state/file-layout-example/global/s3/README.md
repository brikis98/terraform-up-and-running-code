# S3 Remote State Example

This folder contains example [Terraform](https://www.terraform.io/) templates that an [S3](https://aws.amazon.com/s3/)
bucket in an [Amazon Web Services (AWS) account](http://aws.amazon.com/). The S3 bucket can be used for [remote state
storage](https://www.terraform.io/docs/state/remote/).

For more info, please see Chapter 3, "How to Manage Terraform State", of 
*[Terraform: Up and Running](http://www.terraformupandrunning.com)*.

## Pre-requisites

* You must have [Terraform](https://www.terraform.io/) installed on your computer. 
* You must have an [Amazon Web Services (AWS) account](http://aws.amazon.com/).

Please note that this code was written for Terraform 0.8.x.

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

You may want to specify a name for your bucket in `vars.tf` using the `default` parameter:

```hcl
variable "bucket_name" {
  description = "The name of the S3 bucket. Must be globally unique."
  default = "(YOUR_BUCKET_NAME)"
}
```

Validate the templates:

```
terraform plan
```

Deploy the code:

```
terraform apply
```

Clean up when you're done:

```
terraform destroy
```