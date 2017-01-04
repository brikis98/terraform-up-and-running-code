# Web Server Example

This folder contains example [Terraform](https://www.terraform.io/) templates that deploy a single web server (using 
[EC2](https://aws.amazon.com/ec2/)) in an [Amazon Web Services (AWS) account](http://aws.amazon.com/). The web server
listens on port 8080 (which is defined as a variable in this example) and returns the text "Hello, World" for the `/` 
URL.

For more info, please see Chapter 2, "Getting started with Terraform", of 
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

Validate the templates:

```
terraform plan
```

Deploy the code:

```
terraform apply
```

When the `apply` command completes, it will output the public IP address of the server. To test that IP:

```
curl http://(server_public_ip):8080/
```

Clean up when you're done:

```
terraform destroy
```