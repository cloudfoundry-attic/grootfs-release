#!/bin/bash

set -e

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

cf api $CF_API_URL --skip-ssl-validation
cf auth $CF_USERNAME $CF_PASSWORD
cf enable-feature-flag diego_docker
