#!/bin/sh
set -e -x
git config --global user.email "cf-garden+garden-gnome@pivotal.io"
git config --global user.name "I am Groot CI"

git clone ./grootfs-release-master ./release-merged

DEVELOP=$PWD/grootfs-release-develop
cd ./release-merged

git remote add local $DEVELOP
git fetch local

git checkout local/develop

git merge --no-edit master
