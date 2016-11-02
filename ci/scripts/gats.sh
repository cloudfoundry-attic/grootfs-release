#!/bin/bash

set -x -e

export GOPATH=$PWD/garden-runc-release
cd garden-runc-release/src/code.cloudfoundry.org/garden-integration-tests
ginkgo -p -nodes=4 "$@"
