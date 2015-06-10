#!/bin/bash

INSTALL_DIR=$1
cd $INSTALL_DIR

# set up default config
mkdir $INSTALL_DIR/etc/conf.defaults
mv $INSTALL_DIR/etc/redis.conf $INSTALL_DIR/etc/conf.defaults
ln -s $INSTALL_DIR/etc/conf/redis.conf $INSTALL_DIR/etc/redis.conf

# symlink mount points at root to install dir
ln -s $INSTALL_DIR/etc/conf $BITNAMI_APP_VOL_PREFIX/conf
ln -s $INSTALL_DIR/var/data $BITNAMI_APP_VOL_PREFIX/data
ln -s $INSTALL_DIR/var/log $BITNAMI_APP_VOL_PREFIX/logs

# set up logging to stdout
#ln -sf /dev/stdout /logs/redis-server.log

# Conf modifications
sed -i -e 's:\(daemonize\) yes:\1 no:' $INSTALL_DIR/etc/conf.defaults/redis.conf


