#!/bin/bash -e

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
ensure CF_NETWORKING

echo "$CF_SECRETS" > secrets.yml
echo "$CF_UAA_CERTS" > uaa-certs.yml
echo "$CF_ETCD_CERTS" > etcd-certs.yml
echo "$CF_CC_CERTS" > cc-certs.yml
echo "$CF_CONSUL_CERTS" > consul-certs.yml
echo "$CF_DIEGO_CERTS" > diego-certs.yml
echo "$CF_LOGGREGATOR_CERTS" > loggregator-certs.yml
echo "$CF_NETWORKING" > cf-networking.yml

bosh2 int \
  --var=system_domain=${CF_SYSTEM_DOMAIN} \
  --var=uaa_scim_users_admin_password="${CF_PASSWORD}"\
  --var=cf_admin_password="${CF_PASSWORD}"\
  --var=datadog_api_key="${DATADOG_API_KEY}" \
  --var=datadog_app_key="${DATADOG_APPLICATION_KEY}" \
  --var=datadog_metric_prefix="${DATADOG_METRIC_PREFIX}" \
  --vars-file ./secrets.yml \
  --vars-file ./uaa-certs.yml \
  --vars-file ./etcd-certs.yml \
  --vars-file ./cc-certs.yml \
  --vars-file ./consul-certs.yml \
  --vars-file ./diego-certs.yml \
  --vars-file ./loggregator-certs.yml \
  --vars-file ./cf-networking.yml \
  --vars-store ./regenerate-secrets.yml \
  --ops-file grootfs-ci-secrets/deployments/cf-operations/diego-cell-shed.yml \
  --ops-file grootfs-ci-secrets/deployments/cf-operations/diego-cell-custom-agent.yml \
  --ops-file grootfs-ci-secrets/deployments/cf-operations/diego-cell-dstate.yml \
  --ops-file grootfs-ci-secrets/deployments/cf-operations/loopless-bench-errand.yml \
  --ops-file grootfs-ci-secrets/deployments/cf-operations/looped-bench-errand.yml \
  --ops-file git-cf-deployment/operations/test/add-datadog-firehose-nozzle.yml \
  --ops-file git-cf-deployment/operations/aws.yml \
  --ops-file git-cf-deployment/operations/scale-to-one-az.yml \
  --ops-file grootfs-release-develop/manifests/operations/grootfs.yml \
  --ops-file grootfs-ci-secrets/deployments/cf-operations/custom-changes.yml \
  --ops-file grootfs-ci-secrets/deployments/cf-operations/use-latest-releases.yml \
  --ops-file grootfs-ci-secrets/deployments/cf-operations/custom-thanos-changes.yml \
  --ops-file grootfs-diagnostics-develop/manifests/grootfs-diagnostics-ops.yml \
  git-cf-deployment/cf-deployment.yml > manifests/cf.yml

