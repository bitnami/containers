#!/bin/bash
cd $BITNAMI_APP_DIR

# Backup default conf/html
mv conf conf.defaults
mv html html.defaults

# Setup mount point symlinks
ln -s $BITNAMI_APP_DIR/conf $BITNAMI_APP_VOL_PREFIX/conf
ln -s $BITNAMI_APP_DIR/logs $BITNAMI_APP_VOL_PREFIX/logs
ln -s $BITNAMI_APP_DIR/html /app
