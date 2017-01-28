# MySQL on RDS example (production environment)

This folder contains example [Terraform](https://www.terraform.io/) templates that deploy a MySQL database  (using 
[RDS](https://aws.amazon.com/rds/) in an [Amazon Web Services (AWS) account](http://aws.amazon.com/). 

For more info, please see Chapter 4, "How to Create Reusable Infrastructure with Terraform Modules", of 
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

Configure [remote state storage](https://www.terraform.io/docs/state/remote/) using an [S3](https://aws.amazon.com/s3/) 
bucket, filling in your bucket name and region where indicated:

```
terraform remote config \
  -backend=s3 \
  -backend-config="bucket=(YOUR_BUCKET_NAME)" \
  -backend-config="key=prod/data-stores/mysql/terraform.tfstate" \
  -backend-config="region=(YOUR_BUCKET_REGION)" \
  -backend-config="encrypt=true"
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