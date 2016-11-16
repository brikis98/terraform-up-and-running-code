# bash-unit-test-example.sh

This folder shows how extracting your [User Data 
script](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html) into a separate file allows you to write 
unit tests for that file. The folder contains a sample `user-data.sh` Bash script, which fires up a web server on port
8080, plus a simple unit test for it, `bash-unit-test-example.sh`, that runs that server and checks that it works.

For more info, please see Chapter 3, "How to Manage Terraform State", of 
*[Terraform: Up and Running](http://www.terraformupandrunning.com)*.

## Pre-requisites

You must have [busybox](https://busybox.net/) installed on your computer. 

## Quick start

```
./bash-unit-test-example.sh
```