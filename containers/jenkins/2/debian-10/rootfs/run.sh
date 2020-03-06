#!/bin/bash

USER="jenkins"
START_COMMAND="java ${JAVA_OPTS} -jar /opt/bitnami/jenkins/jenkins.war"

if [[ "$(id -u)" = "0" ]]; then
    exec gosu "$USER" bash -c "$START_COMMAND"
else
    exec bash -c "$START_COMMAND"
fi
