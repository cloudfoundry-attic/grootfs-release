#!/bin/bash

set -e

ensure(){
  if [[ "${!1}" == "" ]]
  then
    echo "ERROR: ${1} param must be defined"
    exit 1
  fi
}

ensure CONCOURSE_USERNAME
ensure CONCOURSE_PASSWORD
ensure GITHUB_CLIENT_ID
ensure GITHUB_CLIENT_SECRET

bosh2 int \
  --var=concourse_username=${CONCOURSE_USERNAME} \
  --var=concourse_password=${CONCOURSE_PASSWORD} \
  --var=github_client_id=${GITHUB_CLIENT_ID} \
  --var=github_client_secret=${GITHUB_CLIENT_SECRET} \
  grootfs-ci-secrets/deployments/concourse/concourse.yml > manifests/concourse.yml
