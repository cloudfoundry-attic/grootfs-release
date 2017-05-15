#!/bin/bash

set -x -e

cd vizzini-test-suite

go get -t -d -v ./...

ginkgo -nodes=8 \
  -skip="{LOCAL}" \
  -randomizeAllSpecs \
  -progress \
  -trace \
  "$@" \
  -- \
  --routable-domain-suffix=${ROUTABLE_DOMAIN} \
  --host-address=${CELL_ADDRESS} \
  --bbs-address=https://${BBS_ADDRESS}:8889 \
  --bbs-client-cert=./cert \
  --bbs-client-key=./key \
  --ssh-address=ssh.${ROUTABLE_DOMAIN}:2222 \
  --ssh-password=${SSH_PASSWORD} \

