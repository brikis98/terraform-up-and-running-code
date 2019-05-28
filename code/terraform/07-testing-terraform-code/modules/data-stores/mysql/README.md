# MySQL  

This folder contains an example [Terraform](https://www.terraform.io/) configuration that deploys a MySQL database 
(using [RDS](https://aws.amazon.com/rds/) in an [Amazon Web Services (AWS) account](http://aws.amazon.com/). 

For more info, please see Chapter 7, "How to test Terraform code", of 
*[Terraform: Up and Running](http://www.terraformupandrunning.com)*.

## Quick start

Terraform modules are not meant to be deployed directly. Instead, you should be including them in other Terraform 
configurations. See [live/stage/data-stores/mysql](../../../live/stage/data-stores/mysql) and
[live/prod/data-stores/mysql](../../../live/prod/data-stores/mysql) for examples.