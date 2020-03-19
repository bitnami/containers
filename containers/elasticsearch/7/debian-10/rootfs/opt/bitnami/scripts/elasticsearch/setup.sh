#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libelasticsearch.sh

# Load Elasticsearch environment variables
eval "$(elasticsearch_env)"

# Ensure kernel settings are valid
elasticsearch_validate_kernel
# Ensure Elasticsearch environment variables settings are valid
elasticsearch_validate
# Ensure Elasticsearch is stopped when this script ends
trap "elasticsearch_stop" EXIT
# Ensure 'daemon' user exists when running as 'root'
am_i_root && ensure_user_exists "$ELASTICSEARCH_DAEMON_USER" "$ELASTICSEARCH_DAEMON_GROUP"
# Ensure Elasticsearch is initialized
elasticsearch_initialize
# Install Elasticsearch plugins
if [[ -n "$ELASTICSEARCH_PLUGINS" ]]; then
    elasticsearch_install_plugins
fi
