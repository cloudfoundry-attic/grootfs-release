#!/bin/bash

set -e -x

VERSION=$(cat ./grootfs-release-version/number)
if [ -z "$VERSION" ]; then
  echo "missing version number"
  exit 1
fi

echo "$PRIVATE_YML" > grootfs-release-develop/config/private.yml

cd grootfs-release-develop

git config --global user.email "cf-garden+garden-gnome@pivotal.io"
git config --global user.name "I am Groot CI"

bosh -n create release --final --version "$VERSION" --with-tarball --name grootfs
git add -A
git commit -m "release v${VERSION}"

mv releases/grootfs/*.tgz ../final-release/grootfs-${VERSION}.tgz
cp -r . ../release/master

