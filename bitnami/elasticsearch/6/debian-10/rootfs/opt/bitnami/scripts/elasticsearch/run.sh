#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libelasticsearch.sh
. /opt/bitnami/scripts/libos.sh

# Load environment
. /opt/bitnami/scripts/elasticsearch-env.sh

# Constants
EXEC=$(command -v elasticsearch)
ARGS=("-p" "$ELASTICSEARCH_TMP_DIR/elasticsearch.pid")
[[ -z "${ELASTICSEARCH_EXTRA_FLAGS:-}" ]] || ARGS=("${ARGS[@]}" "${ELASTICSEARCH_EXTRA_FLAGS[@]}")
export JAVA_HOME=/opt/bitnami/java

ARGS+=("$@")

info "** Starting Elasticsearch **"
if am_i_root; then
    exec gosu "$ELASTICSEARCH_DAEMON_USER" "$EXEC" "${ARGS[@]}"
else
    exec "$EXEC" "${ARGS[@]}"
fi
