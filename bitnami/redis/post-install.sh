#!/bin/bash

INSTALL_DIR=$1
cd $INSTALL_DIR

# remove unneeded files
rm -rf $INSTALL_DIR/scripts

# set up default config
mkdir $INSTALL_DIR/etc/conf.defaults
mv $INSTALL_DIR/etc/redis.conf $INSTALL_DIR/etc/conf.defaults
ln -s $INSTALL_DIR/etc/conf/redis.conf $INSTALL_DIR/etc/redis.conf

# set up data
mkdir $INSTALL_DIR/var/data

# symlink mount points at root to install dir
ln -s $INSTALL_DIR/etc/conf /conf
ln -s $INSTALL_DIR/var/data /data
ln -s $INSTALL_DIR/var/log /logs

# set up logging to stdout
#ln -sf /dev/stdout /logs/redis-server.log

# Conf modifications
sed -i -e 's:\(dir '$INSTALL_DIR'/var\):\1/data:' $INSTALL_DIR/etc/conf.defaults/redis.conf
sed -i -e 's:\(daemonize\) yes:\1 no:' $INSTALL_DIR/etc/conf.defaults/redis.conf


