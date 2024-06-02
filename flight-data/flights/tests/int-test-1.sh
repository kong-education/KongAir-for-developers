#!/bin/bash
sleep 5
# Send the request and capture the headers
response=$(http --headers --check-status GET http://localhost:8000/flights)
status_code=$(echo "$response" | grep HTTP | awk '{print $2}')
provider_header=$(echo "$response" | grep x-flights-provider | awk '{print $2}')

# Check the response
if [ "$status_code" -eq 200 ] && [ "$provider_header" == "kong-air" ]; then
  echo "Test passed: Status code is 200 and x-flights-provider is kong-air"
  exit 0
else
  echo "Test failed"
  echo "Status code: $status_code"
  echo "x-flights-provider: $provider_header"
  exit 1
fi