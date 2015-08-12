#!/bin/bash
cd $BITNAMI_APP_DIR

# set up default config
mv conf conf.defaults

# symlink mount points at root to install dir
ln -s $BITNAMI_APP_DIR/webapps/app /app
ln -s $BITNAMI_APP_DIR/conf $BITNAMI_APP_VOL_PREFIX/conf
ln -s $BITNAMI_APP_DIR/logs $BITNAMI_APP_VOL_PREFIX/logs
