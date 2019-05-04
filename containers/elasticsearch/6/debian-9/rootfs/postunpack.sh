#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /libelasticsearch.sh
. /libfs.sh

# Load Elasticsearch environment variables
eval "$(elasticsearch_env)"

for dir in "$ELASTICSEARCH_TMPDIR" "$ELASTICSEARCH_DATADIR" "$ELASTICSEARCH_LOGDIR" "${ELASTICSEARCH_BASEDIR}/plugins" "${ELASTICSEARCH_BASEDIR}/modules" "${ELASTICSEARCH_CONFDIR}/scripts"; do
    ensure_dir_exists "$dir"
done
chmod -R g+rwX "$ELASTICSEARCH_CONFDIR" "$ELASTICSEARCH_TMPDIR" "$ELASTICSEARCH_DATADIR" "$ELASTICSEARCH_LOGDIR" "${ELASTICSEARCH_BASEDIR}/plugins" "${ELASTICSEARCH_BASEDIR}/modules"
