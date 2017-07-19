#!/bin/bash

set -e -x
BUILD_FOLDER=$PWD

ensure(){
  if [[ "${!1}" == "" ]]
  then
    echo "ERROR: ${1} param must be defined"
    exit 1
  fi
}

ensure PRIVATE_YML

VERSION=$(cat ./version/number)
if [ -z "$VERSION" ]; then
  echo "missing version number"
  exit 1
fi

echo "$PRIVATE_YML" > dev-release/config/private.yml

cd dev-release

git config --global user.email "cf-garden+garden-gnome@pivotal.io"
git config --global user.name "I am Groot CI"

bosh2 -n create-release --final --sha2 --version "$VERSION" --tarball ${BUILD_FOLDER}/final-release/${NAME}-${VERSION}.tgz  --name ${NAME}
git add -A
git commit -m "release v${VERSION}"

cp -r . ../release/master

