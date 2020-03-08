#!/bin/bash
# A script that configures a web server

set -e

# Update the apt-get cache
sudo apt-get update

# Install PHP, Apache and git
sudo apt-get install -y php apache2 git

# Copy the code from the repository
sudo git clone https://github.com/brikis98/php-app.git /var/www/html/app

# Start Apache
sudo service apache2 start
