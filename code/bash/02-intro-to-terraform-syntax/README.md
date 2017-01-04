# run-webserver.sh

This folder contains an example of a Bash script that can be used to start a web server that listens on port 8080
and returns the text "Hello, World" for the URL `/`. 

For more info, please see Chapter 2, "Getting started with Terraform", of 
*[Terraform: Up and Running](http://www.terraformupandrunning.com)*.

## Pre-requisites

You must have [busybox](https://busybox.net/) installed on your computer. 

## Quick start

```
./run-webserver.sh
curl http://localhost:8080
```