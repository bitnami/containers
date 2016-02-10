#!/bin/bash
set -e

cd $BITNAMI_APP_DIR

# Disable forking
sed -i -e "s|^[#]*[ ]*fork = .*|fork = false|" $BITNAMI_APP_DIR/conf/mongodb.conf

# Comment out auth and bind_ip config to silence warnings
sed -i -e "s|^auth|# auth|" $BITNAMI_APP_DIR/conf/mongodb.conf
sed -i -e "s|^bind_ip[ ]*=[ ]*0.0.0.0|# bind_ip = 0.0.0.0|" $BITNAMI_APP_DIR/conf/mongodb.conf

# Backup default conf
mv $BITNAMI_APP_DIR/conf $BITNAMI_APP_DIR/conf.defaults

# Remove existing data and logs
rm -rf $BITNAMI_APP_DIR/data
rm -rf $BITNAMI_APP_DIR/logs

# symlink mount points at root to install dir
ln -s $BITNAMI_APP_DIR/conf $BITNAMI_APP_VOL_PREFIX/conf
ln -s $BITNAMI_APP_DIR/data $BITNAMI_APP_VOL_PREFIX/data
ln -s $BITNAMI_APP_DIR/logs $BITNAMI_APP_VOL_PREFIX/logs
