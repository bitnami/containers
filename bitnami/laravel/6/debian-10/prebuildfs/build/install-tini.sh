#!/bin/bash

GPG_KEY="595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7"
GPG_KEY_FINGERPRINT="6380 DC42 8747 F6C3 93FE  ACA5 9A84 159D 7001 A4E5"
SERVERS=("ha.pool.sks-keyservers.net" "hkp://p80.pool.sks-keyservers.net:80" "keyserver.ubuntu.com" "hkp://keyserver.ubuntu.com:80" "pgp.mit.edu")
VERSION="0.13.2"

for server in "${SERVERS[@]}"; do
    gpg --keyserver "$server" --recv-keys "$GPG_KEY" && break || :
done
gpg --fingerprint "$GPG_KEY" | grep -q "$GPG_KEY_FINGERPRINT"
curl --silent -L "https://github.com/krallin/tini/releases/download/v${VERSION}/tini.asc" > "/tmp/tini.asc"
curl --silent -L "https://github.com/krallin/tini/releases/download/v${VERSION}/tini" > "/usr/local/bin/tini"
gpg --verify "/tmp/tini.asc" "/usr/local/bin/tini"
chmod +x "/usr/local/bin/tini"
mkdir -p "/opt/bitnami/licenses"
curl --silent -L "https://raw.githubusercontent.com/krallin/tini/master/LICENSE" > "/opt/bitnami/licenses/tini-${VERSION}.txt"
