#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o nounset

. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libhook.sh

while getopts t:d:h flag
do
    case "$flag" in
        t)
            TERMINATION_GRACE_PERIOD_SECONDS="$OPTARG"
            ;;
        d)
            export BITNAMI_DEBUG="$OPTARG"
            ;;
        h)
            info "Usage: ${0} [ -t <TERMINATION_GRACE_PERIOD_SECONDS> ] [ -d <DEBUG_BOOLEAN> ]"
            exit 0
            ;;
        \?)
            error "Invalid option: -${OPTARG}"
            exit 1
            ;;
        :)
            echo error "Option -${OPTARG} requires an argument."
            exit 1
            ;;
    esac
done

if [[ "${TERMINATION_GRACE_PERIOD_SECONDS:-}" =~ ^[0-9]+$ ]]; then
    RABBITMQ_SYNC_TIMEOUT="$((TERMINATION_GRACE_PERIOD_SECONDS - 10))"
else
    RABBITMQ_SYNC_TIMEOUT="0"
fi

debug "RABBITMQ_SYNC_TIMEOUT is ${RABBITMQ_SYNC_TIMEOUT}"

if debug_execute rabbitmqctl cluster_status && [[ "$RABBITMQ_SYNC_TIMEOUT" -gt 0 ]]; then
    debug "Will wait up to ${RABBITMQ_SYNC_TIMEOUT} seconds for node to make sure cluster is healthy after node shutdown"
    debug_execute timeout "$RABBITMQ_SYNC_TIMEOUT" /opt/bitnami/scripts/rabbitmq/waitforsafeshutdown.sh
    if [[ "$?" -eq 124 ]]; then
        warn "Wait for safe node shutdown has timed out. Continuing to node shutdown anyway."
    fi
fi

rabbitmqctl stop_app
