#!/bin/bash

echo "$BOSH_CERTIFICATES" > certificates.yml
bosh int --path "/certs/ca_cert" certificates.yml > ca_cert.crt

echo "Running performance tests..."
bosh -e $BOSH_ENVIRONMENT --ca-cert ca_cert.crt alias-env bosh-director
bosh -e bosh-director --client $BOSH_CLIENT --client-secret $BOSH_CLIENT_SECRET login
bosh -e bosh-director -d $BOSH_DEPLOYMENT -n delete-deployment
