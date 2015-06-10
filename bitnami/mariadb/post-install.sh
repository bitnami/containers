#!/bin/bash

INSTALL_DIR=$1
cd $INSTALL_DIR

# set up logging to stdout
ln -s /dev/stdout logs/mysqld.log

# set up default config
mkdir conf.defaults
mv my.cnf conf.defaults/
ln -s $INSTALL_DIR/conf/my.cnf my.cnf

# symlink mount points at root to install dir
ln -s $INSTALL_DIR/conf $BITNAMI_APP_VOL_PREFIX/conf
ln -s $INSTALL_DIR/data $BITNAMI_APP_VOL_PREFIX/data
ln -s $INSTALL_DIR/logs $BITNAMI_APP_VOL_PREFIX/logs
