#!/bin/bash
set -e

cd $BITNAMI_APP_DIR

# set up default config
mkdir $BITNAMI_APP_DIR/conf.defaults
mv $BITNAMI_APP_DIR/mongodb.conf $BITNAMI_APP_DIR/conf.defaults
ln -s $BITNAMI_APP_DIR/conf/mongodb.conf $BITNAMI_APP_DIR/mongodb.conf

# symlink mount points at root to install dir
ln -s $BITNAMI_APP_DIR/conf $BITNAMI_APP_VOL_PREFIX/conf
ln -s $BITNAMI_APP_DIR/data $BITNAMI_APP_VOL_PREFIX/data
ln -s $BITNAMI_APP_DIR/log $BITNAMI_APP_VOL_PREFIX/logs

# Temp fix for disabling mongod forking and authentication
sed -i 's/^fork/# fork/' $BITNAMI_APP_DIR/conf.defaults/mongodb.conf
sed -i 's/^auth/# auth/' $BITNAMI_APP_DIR/conf.defaults/mongodb.conf
