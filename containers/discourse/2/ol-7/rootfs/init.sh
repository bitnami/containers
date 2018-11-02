#!/bin/bash

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
