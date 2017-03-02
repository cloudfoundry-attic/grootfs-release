#!/bin/bash

set -e

ensure(){
  if [[ "${!1}" == "" ]]
  then
    echo "ERROR: ${1} param must be defined"
    exit 1
  fi
}

ensure DATADOG_API_KEY
ensure DATADOG_APP_KEY

bosh2 int \
  --var=datadog_api_key=${DATADOG_API_KEY} \
  --var=datadog_app_key=${DATADOG_APP_KEY} \
  grootfs-ci-secrets/deployments/grootfs-bench/grootfs-bench.yml > manifests/grootfs-bench.yml
