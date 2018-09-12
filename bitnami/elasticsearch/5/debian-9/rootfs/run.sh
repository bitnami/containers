#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

. /libelasticsearch.sh
. /libos.sh
eval "$(elasticsearch_env)"

DAEMON=elasticsearch
EXEC=$(which "$DAEMON")
ARGS="-p $ELASTICSEARCH_TMPDIR/elasticsearch.pid -Epath.data=$ELASTICSEARCH_DATADIR"

export JAVA_HOME=/opt/bitnami/java

if am_i_root; then
    exec gosu "$ELASTICSEARCH_DAEMON_USER" "$EXEC" $ARGS
else
    exec "$EXEC" $ARGS
fi

