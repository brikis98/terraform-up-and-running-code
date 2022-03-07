# Kubernetes app

This folder contains an example [Terraform](https://www.terraform.io/) configuration that deploys an app onto a 
Kubernetes cluster using a [Kubernetes 
Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) and configures a load balancer for 
the app using a [Kubernetes Service](https://kubernetes.io/docs/concepts/services-networking/service/). This is
about the simplest, most minimal way to run a K8S app possible: useful for learning, but NOT any sort of production 
usage.

For more info, please see Chapter 7, "Working with Multiple Providers", of
*[Terraform: Up and Running](http://www.terraformupandrunning.com)*.

## Quick start

Terraform modules are not meant to be deployed directly. Instead, you should be including them in other Terraform
configurations. See [examples/kubernetes](../../../examples/kubernetes-eks) for a working example.