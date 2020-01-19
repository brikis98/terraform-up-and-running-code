#!/usr/bin/env bash

set -euo pipefail
set -x

# export DEBIAN_FRONTEND='noninteractive'

# update to latest and remove uncessary
apt clean && \
    apt update && \
    apt-get -y  upgrade && \
    apt-get -y  dist-upgrade && \
    apt -y autoremove && \
    apt-get install -y bsdtar

echo 'finished upgrade'

# variables to identify terraform version
hashicorp_base_url='https://releases.hashicorp.com'
terraform_base_url="${hashicorp_base_url}/terraform"

# getting hyperlinks for terraform releases
terraform_releases="$(curl -fsSL "${terraform_base_url}")"

# getting most recent release
current_terraform_release="$(echo "${terraform_releases}" | grep -oP '\/terraform\/[\d\.]+\/' | grep -oP '[\d\.]+' | head -n 1)"

# getting terraform download url
current_terraform_url="${terraform_base_url}/${current_terraform_release}"

# getting linux amd64 url
# credit for sed is from here: https://github.com/SamuraiWTF/samuraiwtf/pull/103#commitcomment-35941962
terraform_url="$(curl -fsSL "${current_terraform_url}" | sed -n '/href=".*linux_amd64.zip"/p' | awk -F'["]' '{print $10}')"

# local filesystem vars for terraform
terraform_bin_folder='/opt/terraform/bin/'
terraform_bin="${terraform_bin_folder}/terraform"

# creating terraform bin folder
mkdir -p "${terraform_bin_folder}"

# download zip and extract to the bin folder
curl "${hashicorp_base_url}${terraform_url}" | bsdtar -C "${terraform_bin_folder}" -xf -

# make executable
chmod +x "${terraform_bin}"

# add to PATH
ln -s "${terraform_bin}" /usr/local/bin/

# niceties for terraform class
# {} is courtesy of https://github.com/koalaman/shellcheck/wiki/SC2129
{
    # make sure at /vagrant for synced folder and ignore if current dir starts with /vagrant
    printf 'if pwd -P | grep "^/vagrant/" 1> /dev/null ; then : ; else pushd /vagrant ; fi\n'

    # read in AWS id on login
    printf '%s\n' "read -p 'Please input your AWS access key for environment variable use:' key_id && printf 'export AWS_ACCESS_KEY_ID=\"%s\"\n' \${key_id} >> ~/.bashrc"

    # read in AWS secret on login
    printf '%s\n' "read -s -p 'Please input your AWS access key for environment variable use:' access_key && printf 'export AWS_SECRET_ACCESS_KEY_ID=\"%s\"\n' \${access_key} >> ~/.bashrc"

    # removing read commands to not overwrite just given AWS info
    printf '%s\n' "sed -i 's/^read.*//' ~/.bashrc"

    # remove sed commands and exit so env will reload with AWS info
    printf '%s\n' "sed -i 's/^sed.*//' ~/.bashrc && exit"
} >> ~vagrant/.bashrc
