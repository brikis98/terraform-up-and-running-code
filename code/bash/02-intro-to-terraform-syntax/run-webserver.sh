#!/bin/bash
echo "Hello, World" > index.html
nohup busybox httpd -f -p 8080 &
