#!/bin/bash

# Function to check the status code and exit if not zero
check_status() {
  if [ $1 -ne 0 ]; then
    echo "Error: $2"
    exit 1
  fi
}

echo "Step 1: Checkout (Skipped for manual script)"

echo "Step 2: Check Kong Gateway is up"
deck gateway ping --kong-addr http://localhost:8001
check_status $? "Kong Gateway is not up"

echo "Step 3: Lint OpenAPI Specification"
inso lint spec flight-data/flights/flights-openapi.yaml --ci
check_status $? "Linting OpenAPI Specification failed"

echo "Step 4: Generate Kong declarative configuration from Spec"
deck file openapi2kong --spec flight-data/flights/flights-openapi.yaml --output-file flight-data/flights/kong/.generated/kong.yaml
check_status $? "Generating Kong declarative configuration failed"

echo "Step 5: Validate Kong declarative configuration"
deck gateway validate flight-data/flights/kong/.generated/kong.yaml
check_status $? "Validating Kong declarative configuration failed"

echo "Step 6: Check changes against current Kong configuration"
deck gateway diff flight-data/flights/kong/.generated/kong.yaml
check_status $? "Checking changes against current Kong configuration failed"

echo "All steps completed successfully"