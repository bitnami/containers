#!/bin/bash

curl --silent -L https://nami-prod.s3.amazonaws.com/tools/nami/releases/nami-2.0.1-0-linux-x64.tar.gz > /tmp/nami-linux-x64.tar.gz
echo "05e6e1e86cbb419cd80f832650ad06d97bcabca2c3a9e953e81b2674a29cc94e /tmp/nami-linux-x64.tar.gz" | sha256sum --check
mkdir -p /opt/bitnami/nami /opt/bitnami/licenses
tar xzf /tmp/nami-linux-x64.tar.gz --strip 1 -C /opt/bitnami/nami && rm /tmp/nami-linux-x64.tar.gz
curl --silent -L https://raw.githubusercontent.com/bitnami/nami/master/COPYING > /opt/bitnami/licenses/nami-2.0.1-0.txt
