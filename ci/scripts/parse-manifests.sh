#!/bin/bash

SOURCE_MANIFESTS_PATH=grootfs-ci-secrets/deployments
MANIFESTS="gamora/concourse.yml grootfs-bench/aws.yml"

mkdir -p manifests/gamora
mkdir -p manifests/grootfs-bench

for manifest in $MANIFESTS
do
  full_path="${SOURCE_MANIFESTS_PATH}/${manifest}"
  ruby -r erb -e "puts ERB.new(File.read('$full_path')).result" > "manifests/${manifest}"
done
