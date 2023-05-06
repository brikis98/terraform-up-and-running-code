#!/bin/bash

values=$(terraform output -json)

if [ -z "$1" ]; then
  echo "First argument to this script should be one of: introduction, intermediate"
  echo "in order to determine how to output the user values"
fi

let i=0
for username in $(echo $values | jq -r '.students.value[].name'); do
  echo "Instructions repo:     https://github.com/rockholla/terraform-packer-workshop"
  echo "Console URL:           https://rockholla-di.signin.aws.amazon.com/console"
  echo "Username/Alias:        $username"
  password=$(echo $values | jq -r '.passwords.value[]['"$i"']' | base64 --decode | gpg -dq)
  echo "AWS Console Password:  $password"
  region=$(echo $values | jq -r '.students.value['"$i"'].region')
  if [[ "$1" == "introduction" ]]; then
    echo "Exercise 11 Region:    $region"
  elif [[ "$1" == "intermediate" ]]; then
    echo "TODO for region"
  fi
  echo "Instructor email:      patrick+di@rockholla.org"
  echo ""
  echo ""
  echo ""
  let i=i+1
done
