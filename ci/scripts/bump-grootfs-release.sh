#!/bin/bash
git config --global user.email "cf-garden+garden-gnome@pivotal.io"
git config --global user.name "I am Groot CI"

pushd grootfs-git-repo
  head=$(git rev-parse HEAD)
popd

pushd grootfs-release-develop/src/code.cloudfoundry.org/grootfs
  current_sha=$(git rev-parse HEAD)
  git fetch
  git reset --hard $head
popd

pushd grootfs-release-develop
  git add src/code.cloudfoundry.org/grootfs
  git commit -m "Bump grootfs"
  git submodule update --init --recursive
popd

cp -r  grootfs-release-develop/. bumped-release-git
cd bumped-release-git

