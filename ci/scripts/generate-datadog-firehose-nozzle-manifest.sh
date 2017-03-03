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
ensure CF_SECRETS

echo "$CF_SECRETS" > secrets.yml

bosh2 int \
  --var=datadog_api_key=${DATADOG_API_KEY} \
  --var=system_domain=${CF_SYSTEM_DOMAIN} \
  --vars-file ./secrets.yml \
  grootfs-ci-secrets/deployments/gamora/datadog-firehose-nozzle.yml > manifests/datadog-firehose-nozzle.yml
