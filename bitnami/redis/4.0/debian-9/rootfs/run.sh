#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

. /libredis.sh
. /libos.sh
eval "$(redis_env)"


DAEMON=redis-server
EXEC=$(which $DAEMON)
ARGS="$REDIS_BASEDIR/etc/redis.conf --daemonize no $@"
REDIS_EXTRA_FLAGS=${REDIS_EXTRA_FLAGS:-}

# configure extra command line flags
if [[ -n "$REDIS_EXTRA_FLAGS" ]]; then
    warn "REDIS_EXTRA_FLAGS is depredated. Please specify any extra-flag use 'run.sh $REDIS_EXTRA_FLAGS' as command instead"
    ARGS+=" $REDIS_EXTRA_FLAGS"
fi


# If container is started as `root` user
if am_i_root; then
    exec gosu "$REDIS_DAEMON_USER" "$EXEC" $ARGS
else
    exec "$EXEC" $ARGS
fi

