#!/bin/bash
# vim: set ft=sh

set -e -x
BUILD_FOLDER=$PWD

cd garden-runc-release
bosh2 -n create-release --tarball ${BUILD_FOLDER}/bosh-release/garden-runc.tgz --timestamp-version
