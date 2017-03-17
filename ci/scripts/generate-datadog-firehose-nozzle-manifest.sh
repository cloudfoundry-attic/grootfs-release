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
ensure CF_UAA_CERTS

echo "$CF_SECRETS" > secrets.yml
echo "$CF_UAA_CERTS" > uaa.yml

bosh2 int \
  --var=datadog_api_key=${DATADOG_API_KEY} \
  --var=system_domain=${CF_SYSTEM_DOMAIN} \
  --vars-file ./secrets.yml \
  --vars-file ./uaa.yml \
  grootfs-ci-secrets/deployments/firehose-nozzles/datadog-firehose-nozzle.yml > manifests/datadog-firehose-nozzle.yml
