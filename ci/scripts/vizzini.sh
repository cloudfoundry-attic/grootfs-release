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
  --routable-domain-suffix=${ROUTABLE_DOMAIN}
  --host-address=${CELL_ADDRESS} \
  --bbs-address=${BBS_ADDRESS}:8889 \
  --bbs-client-cert=${BBS_CLIENT_CERT} \
  --bbs-client-key=${BBS_CLIENT_KEY} \
  --ssh-address=ssh.${ROUTABLE_DOMAIN} \
  --ssh-password=${SSH_PASSWORD} \

