#!/bin/bash

mkdir /app
chown -R $BITNAMI_APP_USER:$BITNAMI_APP_USER /app/

# Symlink zlib lib for nokogiri
ln -s /opt/bitnami/common/include/zlib.h /usr/local/include/zlib.h
ln -s /opt/bitnami/common/include/zconf.h /usr/local/include/zconf.h
ln -s /opt/bitnami/common/lib/libz.so /usr/lib/libz.so

# Symlink sqlite lib for sqlite3
ln -s /opt/bitnami/sqlite/include/sqlite3.h /usr/local/include/sqlite3.h
ln -s /opt/bitnami/sqlite/lib/libsqlite3.so /usr/lib/libsqlite3.so
