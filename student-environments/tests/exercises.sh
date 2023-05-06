#!/bin/bash

username="$1"
access_key="$2"
secret_key="$3"
region="$4"
exercise_number="$5"
exercise_region="$6"

export AWS_DEFAULT_REGION=$region 
export AWS_ACCESS_KEY_ID=$access_key 
export AWS_SECRET_ACCESS_KEY=$secret_key
export TF_VAR_student_alias=$username

if [ ! -d ./workspace/$username/$exercise_number ]; then
  cp -r ../../exercises/$exercise_number ./workspace/$username/$exercise_number
fi
cd ./workspace/$username/$exercise_number

function common_exec() {
  if ! docker run --name "${username}-tests" --rm -e AWS_DEFAULT_REGION=$region -e AWS_ACCESS_KEY_ID=$access_key -e AWS_SECRET_ACCESS_KEY=$secret_key -e TF_VAR_student_alias=$username -v $(pwd):/workdir terraform-workshop/terraform:latest sh -c "$@"; then
  	touch ../errored
  	exit 1
  fi
}

random_seconds=$(jot -r 1 2 15)
sleep $random_seconds
if [[ "$exercise_number" == "03" ]]; then
  common_exec "terraform init && terraform apply -auto-approve && sleep 120 && terraform destroy -auto-approve"
elif [[ "$exercise_number" == "11" ]]; then
  common_exec "terraform init && terraform apply -var aws_region=$exercise_region -auto-approve && sleep 120 && terraform destroy -var aws_region=$exercise_region -auto-approve"
fi
