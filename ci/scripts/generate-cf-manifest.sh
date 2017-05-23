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
ensure CF_ETCD_CERTS
ensure CF_CC_CERTS
ensure CF_CONSUL_CERTS
ensure CF_DIEGO_CERTS
ensure CF_LOGGREGATOR_CERTS
ensure IAAS

echo "$CF_SECRETS" > secrets.yml
echo "$CF_UAA_CERTS" > uaa-certs.yml
echo "$CF_ETCD_CERTS" > etcd-certs.yml
echo "$CF_CC_CERTS" > cc-certs.yml
echo "$CF_CONSUL_CERTS" > consul-certs.yml
echo "$CF_DIEGO_CERTS" > diego-certs.yml
echo "$CF_LOGGREGATOR_CERTS" > loggregator-certs.yml

# keeping both cf_admin_password and uaa_scim_users_admin_password for the moment because of backwards compatibility
bosh2 int \
  --var=system_domain=${CF_SYSTEM_DOMAIN} \
  --var=uaa_scim_users_admin_password="${CF_PASSWORD}"\
  --var=cf_admin_password="${CF_PASSWORD}"\
  --vars-file ./secrets.yml \
  --vars-file ./uaa-certs.yml \
  --vars-file ./etcd-certs.yml \
  --vars-file ./cc-certs.yml \
  --vars-file ./consul-certs.yml \
  --vars-file ./diego-certs.yml \
  --vars-file ./loggregator-certs.yml \
  --vars-store ./regenerate-secrets.yml \
  --ops-file git-cf-deployment/operations/${IAAS}.yml \
  --ops-file git-cf-deployment/operations/scale-to-one-az.yml \
  --ops-file grootfs-release-develop/manifests/operations/grootfs.yml \
  --ops-file grootfs-ci-secrets/deployments/cf-operations/custom-changes.yml \
  --ops-file grootfs-ci-secrets/deployments/cf-operations/grootfs-long-running-bench.yml \
  --ops-file grootfs-ci-secrets/deployments/cf-operations/cf-resize.yml \
  --ops-file grootfs-ci-secrets/deployments/cf-operations/use-latest-releases.yml \
  --ops-file grootfs-ci-secrets/deployments/cf-operations/datadog-firehose-nozzle.yml \
  --ops-file diego-release-git/operations/add-vizzini-errand.yml \
  git-cf-deployment/cf-deployment.yml > manifests/cf.yml
