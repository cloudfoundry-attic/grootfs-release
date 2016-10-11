#!/bin/bash
git config --global user.email "cf-garden+garden-gnome@pivotal.io"
git config --global user.name "I am Groot CI"

pushd grootfs-git-repo
  head=$(git rev-parse HEAD)
popd

pushd grootfs-release-develop/src/code.cloudfoundry.org/grootfs
  git fetch
  git reset --hard $head
popd

pushd grootfs-release-develop
  git add src/code.cloudfoundry.org/grootfs
  grootfs_changes=$(git diff --cached --submodule src/code.cloudfoundry.org/grootfs | tail -n +2)
  git commit -m "$(printf "Bump grootfs\n\n${grootfs_changes}")"
  git submodule update --init --recursive
popd

cp -r grootfs-release-develop/. bumped-release-git
cd bumped-release-git

