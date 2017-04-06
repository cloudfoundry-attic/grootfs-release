#!/bin/bash
set -e

ensure(){
  if [[ "${!1}" == "" ]]
  then
    echo "ERROR: ${1} param must be defined"
    exit 1
  fi
}

ensure CF_PASSWORD

cat > integration-config/integration_config.json <<EOF
{
  "api": "api.grootfs-performance.cf-app.com",
  "apps_domain": "grootfs-performance.cf-app.com",
  "admin_user": "admin",
  "admin_password": "$CF_PASSWORD",
  "backend": "diego",
  "skip_ssl_validation": true,
  "use_http": true,
  "include_apps": true,
  "include_backend_compatibility": false,
  "include_detect": false,
  "include_docker": true,
  "include_internet_dependent": true,
  "include_privileged_container_support": false,
  "include_route_services": false,
  "include_routing": false,
  "include_security_groups": false,
  "include_services": false,
  "include_ssh": true,
  "include_sso": false,
  "include_tasks": false,
  "include_v3": false,
  "include_zipkin": false,
  "default_timeout": 60
}
EOF
