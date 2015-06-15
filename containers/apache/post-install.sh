#!/bin/bash

cd $BITNAMI_APP_DIR

# Backup default conf/htdocs
mv conf conf.defaults
mv htdocs htdocs.defaults

# Setup mount point symlinks
ln -s $BITNAMI_APP_DIR/conf $BITNAMI_APP_VOL_PREFIX/conf
ln -s $BITNAMI_APP_DIR/logs $BITNAMI_APP_VOL_PREFIX/logs
ln -s $BITNAMI_APP_DIR/htdocs /app

# Log to stdout
ln -sf /dev/stdout logs/access_log
ln -sf /dev/stderr logs/error_log
