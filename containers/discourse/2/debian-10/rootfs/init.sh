#!/bin/bash

for CONF_FILE in discourse.conf database.yml; do
    if [[ -f "/bitnami/discourse/conf/$CONF_FILE" ]]; then
        warn "A persisted configuration file '$CONF_FILE' was found inside '/bitnami/discourse/conf'.  This feature is not supported anymore. Please mount the configuration file at '/opt/bitnami/discourse/mounted-conf' instead."
    fi
done

if [[ "$1" = "nami" && "$2" = "start" ]] || [[ "$1" = "/init.sh" ]]; then
    if [[ "x$4" = "xdiscourse" ]]; then
        nami_initialize postgresql-client discourse
    elif [[ "x$4" = "xdiscourse-sidekiq" ]] ; then
        nami_initialize discourse-sidekiq
    else
        echo "Bear in mind that only discourse and discourse-sidekiq services live within this image. Exiting..."
        exit 1
    fi
    echo "Starting $4..."
fi
