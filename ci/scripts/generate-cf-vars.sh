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
ensure CF_ETCD_CERTS
ensure CF_CC_CERTS
ensure CF_CONSUL_CERTS
ensure CF_DIEGO_CERTS
ensure CF_LOGGREGATOR_CERTS
ensure CF_NETWORKING

echo "$CF_SECRETS" > vars_files/secrets.yml
echo "$CF_UAA_CERTS" > vars_files/uaa-certs.yml
echo "$CF_ETCD_CERTS" > vars_files/etcd-certs.yml
echo "$CF_CC_CERTS" > vars_files/cc-certs.yml
echo "$CF_CONSUL_CERTS" > vars_files/consul-certs.yml
echo "$CF_DIEGO_CERTS" > vars_files/diego-certs.yml
echo "$CF_LOGGREGATOR_CERTS" > vars_files/loggregator-certs.yml
echo "$CF_NETWORKING" > vars_files/networking.yml

