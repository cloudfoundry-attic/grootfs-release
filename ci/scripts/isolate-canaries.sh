#!/bin/bash -e

ensure(){
  if [[ "${!1}" == "" ]]
  then
    echo "ERROR: ${1} param must be defined"
    exit 1
  fi
}

ensure CF_API_URL
ensure CF_PASSWORD
ensure CF_USERNAME
ensure DATADOG_API_KEY
ensure DEPLOYMENT_NAME

cf api $CF_API_URL --skip-ssl-validation
cf auth $CF_USERNAME $CF_PASSWORD
cf target -o system

spaces=(grootfs shed dstate)
for space in ${spaces[@]}
do
  cf create-isolation-segment $space
  cf enable-org-isolation system $space
  cf create-space $space
  cf target -s $space
  cf set-space-isolation-segment $space $space
  pushd diegocanaryapp
    APP_NAME="diego-canary-app-$space" scripts/deploy
  popd
done
