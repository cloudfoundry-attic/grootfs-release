#!/bin/bash
set -e

echo "$BOSH_CERTIFICATES" > certificates.yml
bosh2 int --path "/certs/ca_cert" certificates.yml > ca_cert.crt

echo "Running performance tests..."
bosh2 -e $BOSH_TARGET --ca-cert ca_cert.crt alias-env bosh-director
bosh2 -e bosh-director --client $BOSH_CLIENT --client-secret $BOSH_CLIENT_SECRET login
bosh2 -e bosh-director -d $BOSH_DEPLOYMENT run-errand $ERRAND_NAME
