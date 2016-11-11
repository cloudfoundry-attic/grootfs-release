#!/bin/bash -ex
cd $(dirname $0)/..

FLYRC_TARGET=$1
if [ -z $FLYRC_TARGET ]; then
  echo "No target passed, using 'grootfs-ci'"
  FLYRC_TARGET="grootfs-ci"
fi
[ -z $DEBUG ] && DEBUG=0

check_fly_alias_exists() {
  set +e
  grep $FLYRC_TARGET ~/.flyrc > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo "Please ensure $FLYRC_TARGET exists in ~/.flyrc and that you have run fly login"
    exit 1
  fi
  set -e
}

main() {
  check_fly_alias_exists

  pipeline_name="grootfs"
  [ $DEBUG -eq 1 ] && pipeline_name="grootfs-test"
  vars_name="aws"
  [ $DEBUG -eq 1 ] && vars_name="lite"
  vars_from_path="$HOME/workspace/grootfs-ci-secrets/vars/$vars_name.yml"
  [ $DEBUG -eq 1 ] && FLYRC_TARGET="lite"

  fly --target="$FLYRC_TARGET" set-pipeline --pipeline=$pipeline_name \
    --config=ci/pipeline.yml --load-vars-from=$vars_from_path
}

main
