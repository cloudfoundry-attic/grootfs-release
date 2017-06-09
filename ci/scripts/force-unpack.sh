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

echo "$BOSH_CERTIFICATES" > certificates.yml

bosh2 int --path "/certs/ca_cert" certificates.yml > ca_cert.crt
bosh2 -e $BOSH_TARGET --ca-cert ca_cert.crt alias-env bosh-director
bosh2 -e bosh-director --client $BOSH_CLIENT --client-secret $BOSH_CLIENT_SECRET login

for cell in $(bosh2 -e bosh-director -d cf vms | awk "/$CELL_NAME\// {print $1}")
do
  bosh2 -e bosh-director -d cf ssh $cell -c "sudo touch /var/vcap/packages/cflinuxfs2/*"
done
