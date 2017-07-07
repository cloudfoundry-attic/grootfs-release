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
  vars_name="gcp"
  pipeline_file="pipeline.yml"

  if [ $DEBUG -eq 1 ]; then
    pipeline_name="grootfs-test"
    vars_name="dummy"

    spruce --concourse merge ci/$pipeline_file ci/dummy-pipeline-spruce.yml > ci/dummy_pipeline.yml
    pipeline_file="dummy_pipeline.yml"
  fi

  load_vars_file
  set_pipeline
  expose_pipeline
}

VARS_FILE=/tmp/concourse_vars.yml

trap "rm $VARS_FILE" exit

load_vars_file() {
  touch $VARS_FILE

  echo "datadog-api-key: $(lpass show 'Shared-Garden/grootfs-deployments/datadog-api-keys' --username)" >> $VARS_FILE
  echo "datadog-application-key: $(lpass show 'Shared-Garden/grootfs-deployments/datadog-api-keys' --password)" >> $VARS_FILE
  echo "github-access-token: $(lpass show 'Shared-Garden/Garden-Gnome-Github-Account' --field=api-key)" >> $VARS_FILE
  echo "github-client-id: $(lpass show 'Shared-Garden/grootfs-deployments/github-garden-gnome' --username)" >> $VARS_FILE
  echo "github-client-secret: $(lpass show 'Shared-Garden/grootfs-deployments/github-garden-gnome' --password)" >> $VARS_FILE
  echo "dockerhub-username: $(lpass show 'Shared-Garden/cf-garden-docker' --username)" >> $VARS_FILE
  echo "dockerhub-password: $(lpass show 'Shared-Garden/cf-garden-docker' --password)" >> $VARS_FILE

  echo "gamora-bosh-username: $(lpass show 'Shared-Garden/grootfs-deployments\gamora/bosh-director' --username)" >> $VARS_FILE
  echo "gamora-bosh-password: $(lpass show 'Shared-Garden/grootfs-deployments\gamora/bosh-director' --password)" >> $VARS_FILE
  echo "gamora-cf-username: $(lpass show 'Shared-Garden/grootfs-deployments\gamora/cf-creds' --username)" >> $VARS_FILE
  echo "gamora-cf-password: $(lpass show 'Shared-Garden/grootfs-deployments\gamora/cf-creds' --password)" >> $VARS_FILE
  echo "aws-access-key-id: $(lpass show "Shared-Garden/grootfs-deployments\thanos/aws-keys" --username)" >> $VARS_FILE
  echo "aws-secret-access-key: $(lpass show "Shared-Garden/grootfs-deployments\thanos/aws-keys" --password)" >> $VARS_FILE
  echo "thanos-bosh-username: $(lpass show 'Shared-Garden/grootfs-deployments\thanos/bosh-director' --username)" >> $VARS_FILE
  echo "thanos-bosh-password: $(lpass show 'Shared-Garden/grootfs-deployments\thanos/bosh-director' --password)" >> $VARS_FILE
}

set_pipeline() {
  export gamora_bosh_certs="$(lpass show 'Shared-Garden/grootfs-deployments\gamora/certificates' --notes)"
  gamora_ca_cert=$(ruby -e 'require "yaml"; puts YAML.load(ENV["gamora_bosh_certs"])["certs"]["ca_cert"]')
  fly --target="$flyrc_target" set-pipeline --pipeline=$pipeline_name \
    --config=ci/${pipeline_file} --load-vars-from=$HOME/workspace/grootfs-ci-secrets/vars/$vars_name.yml \
    --load-vars-from=$VARS_FILE \
    --var gnome-private-key="$(lpass show 'Shared-Garden/grootfs-deployments/github-garden-gnome' --notes)" \
    --var garden-tracker-token="$(lpass show 'Shared-Garden/Garden-Gnome-Tracker-Account' --notes)" \
    --var grootfs-release-private-yaml="$(lpass show 'Shared-Garden/grootfs-release-private.yml' --notes)" \
    \
    --var gamora-bosh-certificates="$gamora_bosh_certs" \
    --var gamora-root-ca-cert="$gamora_ca_cert" \
    --var cf-secrets="$(lpass show 'Shared-Garden/grootfs-deployments\gamora/cf-secrets' --notes)" \
    --var cf-uaa-certs="$(lpass show 'Shared-Garden/grootfs-deployments\gamora/cf-uaa-certs' --notes)" \
    --var cf-etcd-certs="$(lpass show 'Shared-Garden/grootfs-deployments\gamora/cf-etcd-certs' --notes)" \
    --var cf-cc-certs="$(lpass show 'Shared-Garden/grootfs-deployments\gamora/cf-cc-certs' --notes)" \
    --var cf-consul-certs="$(lpass show 'Shared-Garden/grootfs-deployments\gamora/cf-consul-certs' --notes)" \
    --var cf-diego-certs="$(lpass show 'Shared-Garden/grootfs-deployments\gamora/cf-diego-certs' --notes)" \
    --var cf-loggregator-certs="$(lpass show 'Shared-Garden/grootfs-deployments\gamora/cf-loggregator-certs' --notes)" \
    --var cf-networking="$(lpass show 'Shared-Garden/grootfs-deployments\gamora/cf-networking' --notes)" \
    --var grootfs-release-private-yaml="$(lpass show 'Shared-Garden/grootfs-release-private.yml' --notes)" \
    \
    --var thanos-bosh-certificates="$(lpass show 'Shared-Garden/grootfs-deployments\thanos/certificates' --notes)" \
    --var thanos-cf-diego-certs="$(lpass show 'Shared-Garden/grootfs-deployments\thanos/cf-diego-certs' --notes)"
}

expose_pipeline() {
  fly --target="$flyrc_target" expose-pipeline --pipeline="$pipeline_name"
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
