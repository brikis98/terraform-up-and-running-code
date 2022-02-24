# KMS CMK example

This folder contains an example [Terraform](https://www.terraform.io/) configuration that creates a [KMS Customer 
Managed Key (CMK)](https://docs.aws.amazon.com/kms/latest/developerguide/concepts.html#key-mgmt) in an 
[Amazon Web Services (AWS) account](http://aws.amazon.com/), and makes the IAM user deploying this configuration the
admin of that CMK. It also contains a Bash script that can use the CMK to encrypt secrets in the format the 
[mysql-kms example](../mysql-kms) expects.

For more info, please see Chapter 6, "Managing Secrets with Terraform", of
*[Terraform: Up and Running](http://www.terraformupandrunning.com)*.

## Pre-requisites

* You must have [Terraform](https://www.terraform.io/) installed on your computer.
* You must have an [Amazon Web Services (AWS) account](http://aws.amazon.com/).

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

Now, you can encrypt secrets using your KMS key by using the `encrypt.sh` script in this folder. For example, to encrypt 
the `db-creds.yml` in this folder, and store the result in the `mysql-kms` folder, you can run:

```
./encrypt.sh \
  alias/kms-cmk-example \
  us-east-2 \
  db-creds.yml \
  ../mysql-kms/db-creds.yml.encrypted
```

After running this command, you should be able to deploy the example in the [mysql-kms folder](../mysql-kms).

Clean up when you're done:

```
terraform destroy
```