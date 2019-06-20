#!/bin/bash
# A script that configures a web server

set -e

# Update the apt-get cache
sudo yum update

# Install PHP
sudo yum install -y php

# Install Apache
sudo yum install -y httpd

# Install Git
sudo yum install -y git

# Copy the code from the repository
sudo git clone https://github.com/brikis98/php-app.git /var/www/html/app

# Start Apache
sudo systemctl start httpd
