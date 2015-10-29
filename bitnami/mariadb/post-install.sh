#!/bin/bash
cd $BITNAMI_APP_DIR

# set up default config
mkdir conf.defaults
mv my.cnf conf.defaults/
ln -s $BITNAMI_APP_DIR/conf/my.cnf my.cnf

# symlink mount points at root to install dir
ln -s $BITNAMI_APP_DIR/conf $BITNAMI_APP_VOL_PREFIX/conf
ln -s $BITNAMI_APP_DIR/data $BITNAMI_APP_VOL_PREFIX/data
ln -s $BITNAMI_APP_DIR/logs $BITNAMI_APP_VOL_PREFIX/logs

# disable DNS lookups
cat >> $BITNAMI_APP_DIR/conf.defaults/my.cnf <<EOF
[mysqld]
skip-name-resolve
EOF
