#!/bin/bash -e

: "${GF_PATHS_CONFIG:=/opt/bitnami/grafana/conf/grafana.ini}"
: "${GF_PATHS_DATA:=/opt/bitnami/grafana/data}"
: "${GF_PATHS_LOGS:=/opt/bitnami/grafana/logs}"
: "${GF_PATHS_PLUGINS:=/opt/bitnami/grafana/data/plugins}"
: "${GF_PATHS_PROVISIONING:=/opt/bitnami/grafana/conf/provisioning}"

if [ ! -z "${GF_INSTALL_PLUGINS}" ]; then
  OLDIFS=$IFS
  IFS=','
  for plugin in ${GF_INSTALL_PLUGINS}; do
    IFS=$OLDIFS
    grafana-cli --pluginsDir "${GF_PATHS_PLUGINS}" plugins install ${plugin}
  done
fi

exec /opt/bitnami/grafana/bin/grafana-server              \
  --homepath=/opt/bitnami/grafana/                         \
  --config="$GF_PATHS_CONFIG"                           \
  cfg:default.log.mode="console"                        \
  cfg:default.paths.data="$GF_PATHS_DATA"               \
  cfg:default.paths.logs="$GF_PATHS_LOGS"               \
  cfg:default.paths.plugins="$GF_PATHS_PLUGINS"         \
  cfg:default.paths.provisioning=$GF_PATHS_PROVISIONING \
  "$@"
