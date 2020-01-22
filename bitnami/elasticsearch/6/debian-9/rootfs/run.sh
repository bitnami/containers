#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace
# shellcheck disable=SC1091

# Load libraries
. /libelasticsearch.sh
. /libos.sh

# Load Elasticsearch environment variables
eval "$(elasticsearch_env)"

# Constants
EXEC=$(command -v elasticsearch)
ARGS=("-p" "$ELASTICSEARCH_TMPDIR/elasticsearch.pid" "-Epath.data=$ELASTICSEARCH_DATADIR")
[[ -z "${ELASTICSEARCH_EXTRA_FLAGS:-}" ]] || ARGS=("${ARGS[@]}" "${ELASTICSEARCH_EXTRA_FLAGS[@]}")
export JAVA_HOME=/opt/bitnami/java

info "** Starting Elasticsearch **"
if am_i_root; then
    exec gosu "$ELASTICSEARCH_DAEMON_USER" "$EXEC" "${ARGS[@]}"
else
    exec "$EXEC" "${ARGS[@]}"
fi
