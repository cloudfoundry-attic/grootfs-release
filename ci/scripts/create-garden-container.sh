#!/bin/bash

set -e

ensure(){
  if [[ "${!1}" == "" ]]
  then
    echo "ERROR: ${1} param must be defined"
    exit 1
  fi
}

ensure GARDEN_ENDPOINT
ensure CONTAINER_NAME
ensure BASE_IMAGE

gaol --target ${GARDEN_ENDPOINT} create -n $CONTAINER_NAME -r $BASE_IMAGE
