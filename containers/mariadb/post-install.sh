#!/bin/bash

INSTALL_DIR=$1
cd $INSTALL_DIR

# remove unneeded files
rm -rf data scripts/myscript.sh scripts/myscript-upgrade.sh

# set up logging to stdout
mkdir logs
ln -s /dev/stdout logs/mysqld.log

# set up default config
mkdir conf.defaults
mv my.cnf conf.defaults/
ln -s $INSTALL_DIR/conf/my.cnf my.cnf

# symlink mount points at root to install dir
ln -s $INSTALL_DIR/conf /conf
ln -s $INSTALL_DIR/data /data
ln -s $INSTALL_DIR/logs /logs
