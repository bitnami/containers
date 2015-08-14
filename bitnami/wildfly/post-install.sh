#!/bin/bash
cd $BITNAMI_APP_DIR

# set up logging logs volume
ln -sf $BITNAMI_APP_DIR/logs/server.log $BITNAMI_APP_DIR/standalone/log/server.log

# symlink mount points at root to install dir
ln -s $BITNAMI_APP_DIR/logs $BITNAMI_APP_VOL_PREFIX/logs
