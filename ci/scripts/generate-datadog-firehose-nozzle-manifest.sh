#!/bin/bash

set -e

if [[ "$DATADOG_API_KEY" == "" ]]
then
  echo "ERROR: DATADOG_API_KEY param must be defined"
  exit 1
fi

if [[ "$CF_SECRETS" == "" ]]
then
  echo "ERROR: CF_SECRETS param must be defined"
  exit 1
fi

echo "$CF_SECRETS" > secrets.yml

bosh2 int \
  --var=datadog_api_key=${DATADOG_API_KEY} \
  --vars-file ./secrets.yml \
  grootfs-ci-secrets/deployments/gamora/datadog-firehose-nozzle.yml > manifests/datadog-firehose-nozzle.yml
