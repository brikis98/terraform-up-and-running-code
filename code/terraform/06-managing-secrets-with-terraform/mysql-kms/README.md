# MySQL with KMS-encrypted files

This folder contains an example [Terraform](https://www.terraform.io/) configuration that deploys a MySQL database
(using [RDS](https://aws.amazon.com/rds/)) in an [Amazon Web Services (AWS) account](http://aws.amazon.com/), reading
the username and password from a KMS-encrypted file. The file should be in the format created by the `encrypt.sh` script
in the [kms-cmk example](../mysql-kms).

For more info, please see Chapter 6, "Managing Secrets with Terraform", of
*[Terraform: Up and Running](http://www.terraformupandrunning.com)*.

## Pre-requisites

* You must have [Terraform](https://www.terraform.io/) installed on your computer.
* You must have an [Amazon Web Services (AWS) account](http://aws.amazon.com/).
* You must deploy the [kms-cmk example](../mysql-kms) first, including running the `encrypt.sh` script to create the
  `db-creds.yml.encrypted` file which contains KMS-encrypted database credentials.

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

Deploy the code:

```
terraform init
terraform apply
```

Clean up when you're done:

```
terraform destroy
```