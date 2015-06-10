#!/bin/bash

INSTALL_DIR=$1
cd $INSTALL_DIR

# Backup default conf/html
mv conf conf.defaults
mv html html.defaults

# Setup mount point symlinks
ln -s $INSTALL_DIR/conf $BITNAMI_APP_VOL_PREFIX/conf
ln -s $INSTALL_DIR/logs $BITNAMI_APP_VOL_PREFIX/logs
ln -s $INSTALL_DIR/html /app
