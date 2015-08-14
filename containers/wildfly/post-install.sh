#!/bin/bash
cd $BITNAMI_APP_DIR

# move the default conf directory
mv $BITNAMI_APP_DIR/standalone/configuration $BITNAMI_APP_DIR/standalone/conf.defaults

# symlink mount points at root to install dir
ln -s $BITNAMI_APP_DIR/standalone/conf $BITNAMI_APP_VOL_PREFIX/conf
ln -s $BITNAMI_APP_DIR/standalone/logs $BITNAMI_APP_VOL_PREFIX/logs
