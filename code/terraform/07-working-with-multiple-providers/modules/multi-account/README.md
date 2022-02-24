# Multi AWS account module

This folder contains an example [Terraform](https://www.terraform.io/) configuration that shows how to have a reusable 
Terraform module work with multiple providers, which gives it the ability to work with multiple [Amazon Web Services 
(AWS) accounts](http://aws.amazon.com/). This module defines `configuration_aliases`, so users of the module can pass
in providers that have authenticated to different AWS accounts (e.g., via IAM roles).

For more info, please see Chapter 7, "Working with Multiple Providers", of
*[Terraform: Up and Running](http://www.terraformupandrunning.com)*.

## Quick start

Terraform modules are not meant to be deployed directly. Instead, you should be including them in other Terraform
configurations. See [examples/multi-account-module](../../examples/multi-account-module) for a working example.
