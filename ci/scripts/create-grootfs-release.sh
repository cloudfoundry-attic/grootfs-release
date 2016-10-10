#!/bin/bash

VERSION=$(cat grootfs-release-version/number)

pushd grootfs-release-develop
  bosh create release --force --version $VERSION --with-tarball --name grootfs
popd

mv grootfs-release-develop/dev_releases/grootfs/grootfs-*.tgz bosh-release/
