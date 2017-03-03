#!/bin/bash

VERSION=$(cat grootfs-release-version/number)
BUILD_FOLDER=$PWD

pushd grootfs-release-develop
  bosh2 create-release --force --version $VERSION --name grootfs --tarball ${BUILD_FOLDER}/bosh-release/grootfs-${VERSION}.tgz
popd
