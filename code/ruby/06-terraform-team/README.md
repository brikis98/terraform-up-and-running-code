# Terraform automated test example

This folder shows an example of how to write automated tests for a web server cluster defined in 
[Terraform](https://www.terraform.io/) templates. The folder contains a Ruby script, `terraform-test.rb`, that will 
apply your Terraform configurations and then test the web server cluster URL to make sure it returns "Hello, World". 

For more info, please see Chapter 6, "How to use Terraform as a Team", of 
*[Terraform: Up and Running](http://www.terraformupandrunning.com)*.

## Pre-requisites

* You must have [Ruby](https://www.ruby-lang.org/) installed on your computer.
* You must have [Terraform](https://www.terraform.io/) installed on your computer. 
* You must have an [Amazon Web Services (AWS) account](http://aws.amazon.com/).

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

Deploy a test database of some sort that the web server cluster can connect to. For example, you could deploy the
Terraform configurations under 
[code/terraform/06-terraform-team/live/stage/data-stores/mysql](/code/terraform/06-terraform-team/live/stage/data-stores/mysql).
Make sure to note down the AWS region you're deploying into (e.g. `us-east-1`) as well as the S3 bucket name (e.g.
`my-terraform-state`) and key (e.g. `qa/stage/data-stores/mysql/terraform.tfstate`) you use to store the remote state 
data of the database.

To run the Ruby automated test, navigate to a folder that contains the web server cluster templates, such as 
[code/terraform/06-terraform-team/live/stage/services/webserver-cluster](/code/terraform/06-terraform-team/live/stage/services/webserver-cluster),
and run the following:

```
ruby \
  ../../../../../../ruby/06-terraform-team/terraform-test.rb \
  us-east-1 \
  my-terraform-state \
  qa/stage/data-stores/mysql/terraform.tfstate
```