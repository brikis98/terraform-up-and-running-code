#!/bin/bash

cd ..
values=$(terraform output -json)
cd ./tests

docker build -t terraform-workshop/terraform:latest .

region="us-east-2"
exercise_number="$1"
if [ -z "$exercise_number" ]; then
  echo "first arg should be the exercise number"
  exit 1
fi
find . -name errored | xargs rm

let i=0
for username in $(echo $values | jq -r '.students.value[].name'); do
  access_key=$(echo $values | jq -r '.test_access_keys.value[]['"$i"']')
  secret_key=$(echo $values | jq -r '.test_secret_keys.value[]['"$i"']')
  exercise_region=$(echo $values | jq -r '.students.value['"$i"'].region')
  echo "Executing exercise $exercise_number for $username"
  mkdir -p ./workspace/$username
  (
  	./exercises.sh $username $access_key $secret_key $region $exercise_number $exercise_region
  ) &> ./workspace/$username/$exercise_number.log &
  let i=i+1
done
wait
echo "Any detected errors:"
find . -name errored