#!/bin/bash
cd $BITNAMI_APP_DIR

# symlink mount points at root to install dir
ln -s $BITNAMI_APP_DIR/standalone/log $BITNAMI_APP_VOL_PREFIX/logs
