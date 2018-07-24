#!/bin/bash
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

if [ "${LD_PRELOAD:-}" = '/usr/lib/libnss_wrapper.so' ]; then
        rm -f "$NSS_WRAPPER_PASSWD" "$NSS_WRAPPER_GROUP"
        unset LD_PRELOAD NSS_WRAPPER_PASSWD NSS_WRAPPER_GROUP
fi

nami start --foreground postgresql
