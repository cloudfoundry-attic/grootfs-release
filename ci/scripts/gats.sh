#!/bin/bash

set -e

export GOPATH=$PWD/garden-runc-release-git
cd garden-runc-release-git/src/code.cloudfoundry.org/garden-integration-tests
ginkgo -p -nodes=4 "$@"
