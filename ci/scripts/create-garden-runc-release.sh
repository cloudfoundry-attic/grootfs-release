#!/bin/bash
# vim: set ft=sh

set -e -x

cd garden-runc-release

bosh -n create release --with-tarball

mkdir -p ../bosh-release
mv dev_releases/garden-runc/*.tgz ../bosh-release/garden-runc.tgz

