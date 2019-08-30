# Hello World App 

This folder contains an example [Terraform](https://www.terraform.io/) configuration that defines a module for 
deploying a simple "Hello, World app" across a cluster of web servers (using [EC2](https://aws.amazon.com/ec2/) 
and [Auto Scaling](https://aws.amazon.com/autoscaling/)) with a load balancer (using 
[ELB](https://aws.amazon.com/elasticloadbalancing/)) in an [Amazon Web Services (AWS) 
account](http://aws.amazon.com/).

For more info, please see Chapter 6, "Production-grade Terraform code", of 
*[Terraform: Up and Running](http://www.terraformupandrunning.com)*.

## Quick start

Terraform modules are not meant to be deployed directly. Instead, you should be including them in other Terraform 
configurations. See [live/stage/services/hello-world-app](../../../live/stage/services/hello-world-app) and
[live/prod/services/hello-world-app](../../../live/prod/services/hello-world-app) for examples.