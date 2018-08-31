#!/bin/bash

. /libredis.sh
. /libfs.sh

eval "$(redis_env)"

for dir in "$REDIS_VOLUME" "$REDIS_VOLUME/data" ; do
    ensure_dir_exists "$dir"
done

chmod -R g+rwX /bitnami "$REDIS_VOLUME" "$REDIS_BASEDIR"

