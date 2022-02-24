# EKS Cluster

This folder contains an example [Terraform](https://www.terraform.io/) configuration that deploys a Kubernetes cluster
using [EKS](https://aws.amazon.com/eks/) in an [Amazon Web Services (AWS) account](http://aws.amazon.com/). This is
about the simplest, most minimal EKS cluster possible: useful for learning, but NOT any sort of production usage.

For more info, please see Chapter 7, "Working with Multiple Providers", of
*[Terraform: Up and Running](http://www.terraformupandrunning.com)*.

## Quick start

Terraform modules are not meant to be deployed directly. Instead, you should be including them in other Terraform
configurations. See [examples/kubernetes](../../../examples/kubernetes-eks) for a working example.