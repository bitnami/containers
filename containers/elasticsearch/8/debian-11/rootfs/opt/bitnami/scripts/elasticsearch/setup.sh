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

# Load environment
. /opt/bitnami/scripts/elasticsearch-env.sh

# Ensure Elasticsearch environment variables settings are valid
elasticsearch_validate
# Ensure Elasticsearch is stopped when this script ends
trap "elasticsearch_stop" EXIT
# Ensure 'daemon' user exists when running as 'root'
am_i_root && ensure_user_exists "$ELASTICSEARCH_DAEMON_USER" --group "$ELASTICSEARCH_DAEMON_GROUP"
# Ensure Elasticsearch is initialized
elasticsearch_initialize
# Ensure kernel settings are valid
elasticsearch_validate_kernel
# Install Elasticsearch plugins
elasticsearch_install_plugins
# Ensure custom initialization scripts are executed
elasticsearch_custom_init_scripts
# Ensure all the required keys are added after plugins are installed
elasticsearch_set_keys
