#!/bin/bash

mkdir /app
chown -R $BITNAMI_APP_USER:$BITNAMI_APP_USER /app/

sudo gem install bundler
