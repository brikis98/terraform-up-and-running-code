#!/bin/bash

export db_address=12.34.56.78
export db_port=5555
export server_port=8888

./user-data.sh

output=$(curl "http://localhost:$server_port")

if [[ $output != *"Hello, World"* ]]; then
  echo "Did not get back expected text 'Hello, World'"
fi
