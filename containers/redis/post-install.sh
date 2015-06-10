#!/bin/bash

cd $BITNAMI_APP_DIR

# set up default config
mkdir $BITNAMI_APP_DIR/etc/conf.defaults
mv $BITNAMI_APP_DIR/etc/redis.conf $BITNAMI_APP_DIR/etc/conf.defaults
ln -s $BITNAMI_APP_DIR/etc/conf/redis.conf $BITNAMI_APP_DIR/etc/redis.conf

# symlink mount points at root to install dir
ln -s $BITNAMI_APP_DIR/etc/conf $BITNAMI_APP_VOL_PREFIX/conf
ln -s $BITNAMI_APP_DIR/var/data $BITNAMI_APP_VOL_PREFIX/data
ln -s $BITNAMI_APP_DIR/var/log $BITNAMI_APP_VOL_PREFIX/logs

# set up logging to stdout
#ln -sf /dev/stdout /logs/redis-server.log

# Conf modifications
sed -i -e 's:\(daemonize\) yes:\1 no:' $BITNAMI_APP_DIR/etc/conf.defaults/redis.conf


