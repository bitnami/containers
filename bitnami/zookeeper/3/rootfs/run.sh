#!/bin/bash
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

export ZOO_LOG_DIR=/opt/bitnami/zookeeper/logs
export ZOOPIDFILE=/opt/bitnami/zookeeper/tmp/zookeeper.pid

info "Starting ZooKeeper..."
/opt/bitnami/zookeeper/bin/zkServer.sh start && tail -f ${ZOO_LOG_DIR}/zookeeper.out
