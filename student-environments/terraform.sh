#!/bin/bash

export TF_VAR_pgp_key=$(gpg --export "rockholla-di" | base64)
terraform init
terraform $@
