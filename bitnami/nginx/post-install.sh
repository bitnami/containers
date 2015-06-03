#!/bin/bash

INSTALL_DIR=$1
cd $INSTALL_DIR

# Backup default conf/html
mv conf conf.defaults
mv html html.defaults

# Setup mount point symlinks
ln -s /usr/local/bitnami/nginx/conf /conf
ln -s /usr/local/bitnami/nginx/logs /logs
ln -s /usr/local/bitnami/nginx/html /app

# Log to stdout
ln -sf /dev/stdout logs/access.log
ln -sf /dev/stderr logs/error.log
