#!/bin/bash

set -e

ensure(){
  if [[ "${!1}" == "" ]]
  then
    echo "ERROR: ${1} param must be defined"
    exit 1
  fi
}

ensure CF_SECRETS
ensure CF_UAA_CERTS
ensure CF_SYSTEM_DOMAIN
ensure CF_PASSWORD

echo "$CF_SECRETS" > secrets.yml
echo "$CF_UAA_CERTS" > uaa-certs.yml

bosh2 int \
  --var=system_domain=${CF_SYSTEM_DOMAIN} \
  --var=uaa_scim_users_admin_password="${CF_PASSWORD}"\
  --vars-file ./secrets.yml \
  --vars-file ./uaa-certs.yml \
  --vars-store ./regenerate-secrets.yml \
  --ops-file git-cf-deployment/operations/gcp.yml \
  --ops-file grootfs-release-develop/manifests/operations/grootfs.yml \
  --ops-file grootfs-ci-secrets/deployments/cf-operations/cf-resize.yml \
  --ops-file grootfs-ci-secrets/deployments/cf-operations/use-latest-releases.yml \
  --ops-file grootfs-ci-secrets/deployments/cf-operations/datadog-firehose-nozzle.yml \
  git-cf-deployment/cf-deployment.yml > manifests/cf.yml
