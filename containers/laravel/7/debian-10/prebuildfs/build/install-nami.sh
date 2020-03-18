#!/bin/bash

curl --silent -L https://nami-prod.s3.amazonaws.com/tools/nami/releases/nami-1.0.0-1-linux-x64.tar.gz > /tmp/nami-linux-x64.tar.gz
echo "80488279b056d5e9c183fe34097c5f496715ab16a602afcc9f78d59f15139a16 /tmp/nami-linux-x64.tar.gz" | sha256sum --check
mkdir -p /opt/bitnami/nami /opt/bitnami/licenses
tar xzf /tmp/nami-linux-x64.tar.gz --strip 1 -C /opt/bitnami/nami && rm /tmp/nami-linux-x64.tar.gz
curl --silent -L https://raw.githubusercontent.com/bitnami/nami/master/COPYING > /opt/bitnami/licenses/nami-1.0.0-1.txt
