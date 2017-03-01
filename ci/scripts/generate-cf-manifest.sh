#!/bin/bash

set -e

echo "$CF_SECRETS" > secrets.yml
echo "$CF_UAA_CERTS" > uaa-certs.yml

bosh2 int \
  --var=system_domain=${CF_SYSTEM_DOMAIN} \
  --var=uaa_scim_users_admin_password="${CF_PASSWORD}"\
  --vars-file ./secrets.yml \
  --vars-file ./uaa-certs.yml \
  --vars-store ./regenerate-secrets.yml \
  --ops-file grootfs-ci-secrets/deployments/cf-operations/cats-errand.yml \
  --ops-file git-cf-deployment/operations/gcp.yml \
  --ops-file grootfs-release-develop/manifests/operations/grootfs.yml \
  --ops-file grootfs-ci-secrets/deployments/cf-operations/cf-resize.yml \
  --ops-file grootfs-ci-secrets/deployments/cf-operations/use-latest-releases.yml \
  git-cf-deployment/cf-deployment.yml > manifests/cf.yml
