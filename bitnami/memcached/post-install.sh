#!/bin/bash
cd $BITNAMI_APP_DIR

# set up logging to stdout
mkdir logs
ln -s /dev/stdout logs/memcached.log

# symlink mount points at root to install dir
ln -s $BITNAMI_APP_DIR/logs $BITNAMI_APP_VOL_PREFIX/logs
