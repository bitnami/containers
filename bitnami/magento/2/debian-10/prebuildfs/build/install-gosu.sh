#!/bin/bash

VERSION="1.11"
SHA256="0b843df6d86e270c5b0f5cbd3c326a04e18f4b7f9b8457fa497b0454c4b138d7"

curl --silent -L "https://github.com/tianon/gosu/releases/download/${VERSION}/gosu-amd64" > "/usr/local/bin/gosu"
echo "$SHA256" "/usr/local/bin/gosu" | sha256sum --check
chmod u+x "/usr/local/bin/gosu"
mkdir -p "/opt/bitnami/licenses"
curl --silent -L "https://raw.githubusercontent.com/tianon/gosu/master/LICENSE" > "/opt/bitnami/licenses/gosu-${VERSION}.txt"
