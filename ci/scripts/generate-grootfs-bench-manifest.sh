#!/bin/bash

set -e

if [[ "$DATADOG_API_KEY" == "" ]]
then
  echo "ERROR: DATADOG_API_KEY param must be defined"
  exit 1
fi

if [[ "$DATADOG_APP_KEY" == "" ]]
then
  echo "ERROR: DATADOG_APP_KEY param must be defined"
  exit 1
fi

bosh2 int \
  --var=datadog_api_key=${DATADOG_API_KEY} \
  --var=datadog_app_key=${DATADOG_APP_KEY} \
  grootfs-ci-secrets/deployments/grootfs-bench/grootfs-bench.yml > manifests/grootfs-bench.yml
