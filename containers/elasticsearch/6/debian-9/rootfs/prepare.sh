#!/bin/bash

. /libelasticsearch.sh
. /libfs.sh

eval "$(elasticsearch_env)"

for dir in "$ELASTICSEARCH_TMPDIR" "$ELASTICSEARCH_DATADIR" "$ELASTICSEARCH_LOGDIR" "$ELASTICSEARCH_BASEDIR/plugins" "$ELASTICSEARCH_BASEDIR/modules" "$ELASTICSEARCH_CONFDIR/scripts"; do
    ensure_dir_exists "$dir"
done

chmod -R g+rwX "$ELASTICSEARCH_CONFDIR" "$ELASTICSEARCH_TMPDIR" "$ELASTICSEARCH_DATADIR" "$ELASTICSEARCH_LOGDIR" "$ELASTICSEARCH_BASEDIR/plugins" "$ELASTICSEARCH_BASEDIR/modules"

ensure_user_exists "$ELASTICSEARCH_DAEMON_USER"
