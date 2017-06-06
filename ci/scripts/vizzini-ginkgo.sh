#!/bin/bash -l

# set -x
set -e

ensure(){
  if [[ "${!1}" == "" ]]
  then
    echo "ERROR: ${1} param must be defined"
    exit 1
  fi
}

ensure BOSH_CERTIFICATES
ensure BOSH_TARGET
ensure BOSH_CLIENT
ensure BOSH_CLIENT_SECRET
ensure DIEGO_CREDENTIALS
ensure ENV
ensure GINKGO_NODES
ensure VERBOSE
ensure PLACEMENT_TAGS

cd diego-release-git
export GOPATH=$(pwd)
cd src/code.cloudfoundry.org/vizzini

echo "$DIEGO_CREDENTIALS" | python -c 'import yaml; import sys; print yaml.load(sys.stdin).get("diego_bbs_client").get("private_key")' > client.key
echo "$DIEGO_CREDENTIALS" | python -c 'import yaml; import sys; print yaml.load(sys.stdin).get("diego_bbs_client").get("certificate")' > client.crt
echo "$BOSH_CERTIFICATES" > certificates.yml

SSH_PROXY_PASSWORD=$(echo "$DIEGO_CREDENTIALS" | python -c 'import yaml; import sys; print yaml.load(sys.stdin).get("ssh_proxy_diego_credentials")')

bosh2 int --path "/certs/ca_cert" certificates.yml > ca_cert.crt
bosh2 -e $BOSH_TARGET --ca-cert ca_cert.crt alias-env bosh-director
bosh2 -e bosh-director --client $BOSH_CLIENT --client-secret $BOSH_CLIENT_SECRET login
DIEGO_BRAIN_ADDRESS=$(bosh2 -e bosh-director -d cf vms | awk '/diego-brain/ {print $4}')
DIEGO_BBS_ADDRESS=$(bosh2 -e bosh-director -d cf vms | awk '/diego-bbs/ {print $4}')

EXITSTATUS=0

ginkgo \
  -nodes=${GINKGO_NODES} \
  -v=${VERBOSE} \
  -progress \
  -trace \
  -keepGoing \
  -- \
  --bbs-client-cert=./client.crt \
  --bbs-client-key=./client.key \
  --bbs-address="https://${DIEGO_BBS_ADDRESS}:8889" \
  --ssh-address="${DIEGO_BRAIN_ADDRESS}:2222" \
  --rep-placement-tags=$PLACEMENT_TAGS \
  --ssh-password=${SSH_PROXY_PASSWORD} \
  --routable-domain-suffix="grootfs-${ENV}.cf-app.com"

echo "Vizzini Complete; exit status: $EXITSTATUS"
