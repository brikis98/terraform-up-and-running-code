# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.
  config.vm.box = "bento/ubuntu-18.04"
  config.vm.provision "shell", path: "./prov_vagrant/prov.sh"
end
