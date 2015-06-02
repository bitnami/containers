#!/bin/bash

INSTALL_DIR=$1
cd $INSTALL_DIR

# Backup default conf/htdocs
mv conf conf.defaults
mv htdocs htdocs.defaults

# Setup mount point symlinks
ln -s /usr/local/bitnami/apache2/conf /conf
ln -s /usr/local/bitnami/apache2/logs /logs
ln -s /usr/local/bitnami/apache2/htdocs /app

# Log to stdout
ln -sf /dev/stdout logs/access_log
ln -sf /dev/stderr logs/error_log
