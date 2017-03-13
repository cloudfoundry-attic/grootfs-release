#!/bin/bash

set -e

BUILD_FOLDER=$PWD

ensure(){
  if [[ "${!1}" == "" ]]
  then
    echo "ERROR: ${1} param must be defined"
    exit 1
  fi
}

ensure DATADOG_API_KEY
ensure DATADOG_APP_KEY

generate_manifest() {
  manifest=$1
  bosh2 int \
    --var=datadog_api_key=${DATADOG_API_KEY} \
    --var=datadog_app_key=${DATADOG_APP_KEY} \
    $manifest > $BUILD_FOLDER/manifests/$manifest
}

cd grootfs-ci-secrets/deployments/grootfs-bench

for manifest in grootfs-bench-*.yml
do
  generate_manifest $manifest
done


