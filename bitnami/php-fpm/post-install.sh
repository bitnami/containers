#!/bin/bash
mkdir /app
# set up default config
mkdir $BITNAMI_APP_DIR/etc/conf.defaults
mkdir $BITNAMI_APP_DIR/etc/conf
mv $BITNAMI_APP_DIR/etc/php-fpm.conf $BITNAMI_APP_DIR/etc/conf.defaults
ln -s $BITNAMI_APP_DIR/etc/conf/php-fpm.conf $BITNAMI_APP_DIR/etc/php-fpm.conf

# Temp fix for disabling php-fpm caching
sudo sed --follow-symlinks -i -e 's/\(opcache\.enable=\)1/\10/g' $BITNAMI_PREFIX/php/etc/php.ini
mv $BITNAMI_APP_DIR/etc/php.ini $BITNAMI_APP_DIR/etc/conf.defaults
ln -s $BITNAMI_APP_DIR/etc/conf/php.ini $BITNAMI_APP_DIR/etc/php.ini

chown -R $BITNAMI_APP_USER:$BITNAMI_APP_USER /app/ $BITNAMI_APP_DIR/etc/conf $BITNAMI_APP_DIR/var/log
ln -s $BITNAMI_APP_DIR/var/log $BITNAMI_APP_VOL_PREFIX/logs
ln -s $BITNAMI_APP_DIR/etc/conf $BITNAMI_APP_VOL_PREFIX/conf
