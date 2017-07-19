#!/bin/bash

set -e

VERSION=$(cat version/number)
BUILD_FOLDER=$PWD

pushd release
  bosh2 create-release --force --version $VERSION --name ${NAME} --tarball ${BUILD_FOLDER}/bosh-release/${NAME}-${VERSION}.tgz
popd
