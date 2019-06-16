# Application Load Balancer 

This folder contains an example [Terraform](https://www.terraform.io/) configuration that defines a module for 
deploying a load balancer (using [ELB](https://aws.amazon.com/elasticloadbalancing/)) in an 
[Amazon Web Services (AWS) account](http://aws.amazon.com/).

For more info, please see Chapter 8, "How to use Terraform as a Team", of 
*[Terraform: Up and Running](http://www.terraformupandrunning.com)*.

## Quick start

Terraform modules are not meant to be deployed directly. Instead, you should be including them in other Terraform 
configurations. See [live/stage/networking/alb](../../../live/stage/networking/alb) and
[live/prod/networking/alb](../../../live/prod/networking/alb) for examples.