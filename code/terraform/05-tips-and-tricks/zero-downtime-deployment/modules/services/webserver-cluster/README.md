# Web server cluster module example

This folder contains example [Terraform](https://www.terraform.io/) templates that define a module for deploying a 
cluster of web servers (using [EC2](https://aws.amazon.com/ec2/) and [Auto 
Scaling](https://aws.amazon.com/autoscaling/)) and a load balancer (using 
[ELB](https://aws.amazon.com/elasticloadbalancing/)) in an [Amazon Web Services (AWS) account](http://aws.amazon.com/). 
The load balancer listens on port 80 and returns the text "Hello, World" for the `/` URL. The Auto Scaling Group is 
able to do a zero-downtime deployment when you update any of it's properties.

For more info, please see Chapter 5, "Terraform Tips & Tricks: Loops, If-Statements, Deployment, and Gotchas", of 
*[Terraform: Up and Running](http://www.terraformupandrunning.com)*.

## Quick start

Terraform modules are not meant to be deployed directly. Instead, you should be using them from other templates. See
[live/stage/services/webserver-cluster](../../../live/stage/services-webserver-cluster) and
[live/prod/services/webserver-cluster](../../../live/prod/services-webserver-cluster) for examples.