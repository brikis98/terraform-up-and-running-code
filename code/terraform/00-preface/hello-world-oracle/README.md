# Terraform "Hello, World" example for Oracle Cloud OCI

This folder contains a "Hello, World" example of a [Terraform](https://www.terraform.io/) configuration. The configuration 
deploys a single server in a [Google Cloud](http://cloud.google.com/). 

For more info, please see the preface of *[Terraform: Up and Running](http://www.terraformupandrunning.com)*.

## Pre-requisites

* You must have [Terraform](https://www.terraform.io/) installed on your computer. 
* You must have a [Oracle Cloud](TODO) account.

## Quick start

**Please note that this example will deploy real resources into your Google Cloud account. We have made every effort to ensure 
all the resources qualify for the free tier, but we are not responsible for any charges you may incur.** 

Configure your account as explained [here](https://learn.hashicorp.com/tutorials/terraform/google-cloud-platform-build?in=terraform/gcp-get-started).

Deploy the code:

```
terraform init
terraform apply
```

Clean up when you're done:

```
terraform destroy
```