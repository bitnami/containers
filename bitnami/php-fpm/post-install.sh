#!/bin/bash
mkdir /app
# set up default config
mkdir $BITNAMI_APP_DIR/etc/conf.defaults
mkdir $BITNAMI_APP_DIR/etc/conf
mv $BITNAMI_APP_DIR/etc/php-fpm.conf $BITNAMI_APP_DIR/etc/conf.defaults
ln -s $BITNAMI_APP_DIR/etc/conf/php-fpm.conf $BITNAMI_APP_DIR/etc/php-fpm.conf

chown -R $BITNAMI_APP_USER:$BITNAMI_APP_USER /app/ $BITNAMI_APP_DIR/etc/conf $BITNAMI_APP_DIR/var/log
ln -s $BITNAMI_APP_DIR/var/log $BITNAMI_APP_VOL_PREFIX/logs
ln -s $BITNAMI_APP_DIR/etc/conf $BITNAMI_APP_VOL_PREFIX/conf
