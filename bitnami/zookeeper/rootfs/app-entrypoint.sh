#!/bin/bash
set -e


cd /opt/bitnami/kafka

bin/zkServer.sh start 

exec /entrypoint.sh "$@"
