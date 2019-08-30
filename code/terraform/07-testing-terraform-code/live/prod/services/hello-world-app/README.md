# Hello-world app example (prod environment)

This folder contains an example [Terraform](https://www.terraform.io/) configuration that deploys a simple "Hello, 
World" application across a cluster of web servers (using [EC2](https://aws.amazon.com/ec2/) and 
[Auto Scaling](https://aws.amazon.com/autoscaling/)) in an [Amazon Web Services (AWS) account](http://aws.amazon.com/). 
This module also adds a listener rule to a load balancer (using [ELB](https://aws.amazon.com/elasticloadbalancing/)) 
to respond with "Hello, World" to the `/` URL. 

For more info, please see Chapter 7, "How to test Terraform code", of 
*[Terraform: Up and Running](http://www.terraformupandrunning.com)*.

## Pre-requisites

* You must have [Terraform](https://www.terraform.io/) installed on your computer. 
* You must have an [Amazon Web Services (AWS) account](http://aws.amazon.com/).
* You must deploy the MySQL database in [data-stores/mysql](../../data-stores/mysql) BEFORE deploying the configuration 
  in this folder.

Please note that this code was written for Terraform 0.12.x.

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

In `variables.tf`, fill in the name of the S3 bucket and key where the remote state is stored for the MySQL database 
and ALB (you must deploy the configurations in [data-stores/mysql](../../data-stores/mysql) first):

```hcl
variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket used for the database's remote state storage"
  type        = string
  default     = "<YOUR BUCKET NAME>"
}

variable "db_remote_state_key" {
  description = "The name of the key in the S3 bucket used for the database's remote state storage"
  type        = string
  default     = "<YOUR STATE PATH>"
}
```

Deploy the code:

```
terraform init
terraform apply
```

When the `apply` command completes, it will output the DNS name of the load balancer. To test the load balancer:

```
curl http://<alb_dns_name>/
```

Clean up when you're done:

```
terraform destroy
```