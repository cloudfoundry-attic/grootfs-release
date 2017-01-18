#!/bin/bash -ex
cd $(dirname $0)/..

flyrc_target=$1
if [ -z $flyrc_target ]; then
  echo "No target passed, using 'grootfs-ci'"
  flyrc_target="grootfs-ci"
fi
[ -z $DEBUG ] && DEBUG=0

main() {
  check_fly_alias_exists
	sync_and_login

  pipeline_name="grootfs"
  [ $DEBUG -eq 1 ] && pipeline_name="grootfs-test"
  vars_name="gcp"
  [ $DEBUG -eq 1 ] && vars_name="lite"

  vars_from_lpass="/tmp/$vars_name.yml"
  trap 'rm "$vars_from_lpass"' EXIT

  lpass show "Shared-Garden/grootfs-concourse-vars-$vars_name" --notes > "$vars_from_lpass"
  cat $HOME/workspace/grootfs-ci-secrets/vars/$vars_name.yml >> "$vars_from_lpass"

  [ $DEBUG -eq 1 ] && flyrc_target="lite"

  fly --target="$flyrc_target" set-pipeline --pipeline=$pipeline_name \
    --config=ci/pipeline.yml --load-vars-from=$vars_from_lpass
}

check_fly_alias_exists() {
  set +e
  grep $flyrc_target ~/.flyrc > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo "Please ensure $flyrc_target exists in ~/.flyrc and that you have run fly login"
    exit 1
  fi
  set -e
}

sync_and_login() {
  fly -t $flyrc_target sync

  set +e
  fly -t $flyrc_target containers > /dev/null 2>&1
  if [[ $? -ne 0 ]]; then
    fly -t $flyrc_target login
  fi
  set -e
}

main
