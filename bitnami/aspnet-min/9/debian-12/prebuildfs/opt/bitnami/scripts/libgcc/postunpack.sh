#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091,SC1090

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

DEST_DIR="/rootfs"

paths_to_mirror=(
    # Package 'libc6'
    /etc/ld.so.conf.d/
    /etc/ld.so.conf
    /etc/rpc
    /etc/nsswitch.conf
    /usr/lib/*linux-gnu/gconv/
    /usr/lib/*linux-gnu/libpcprofile.so
    /usr/lib/*linux-gnu/libBrokenLocale.so*
    /usr/lib/*linux-gnu/libanl.so*
    /usr/lib/*linux-gnu/libc.so*
    /usr/lib/*linux-gnu/libc_malloc_debug.so*
    /usr/lib/*linux-gnu/libdl.so*
    /usr/lib/*linux-gnu/libm.so*
    /usr/lib/*linux-gnu/libmemusage.so
    /usr/lib/*linux-gnu/libnsl.so*
    /usr/lib/*linux-gnu/libnss_compat.so*
    /usr/lib/*linux-gnu/libnss_dns.so*
    /usr/lib/*linux-gnu/libnss_files.so*
    /usr/lib/*linux-gnu/libnss_hesiod.so*
    /usr/lib/*linux-gnu/libpthread.so*
    /usr/lib/*linux-gnu/libresolv.so*
    /usr/lib/*linux-gnu/librt.so*
    /usr/lib/*linux-gnu/libthread_db.so*
    /usr/lib/*linux-gnu/libutil.so*
    # Package 'openssl'
    /etc/ssl/openssl.cnf
    # Package 'libssl3'
    /usr/lib/*linux-gnu/ossl-modules
    /usr/lib/*linux-gnu/engines-3
    /usr/lib/*linux-gnu/libcrypto.so*
    /usr/lib/*linux-gnu/libssl.so*
    # Package 'libgomp1'
    /usr/lib/*linux-gnu/libgomp.so*
    # Package 'libstdc++'
    /usr/lib/*linux-gnu/libstdc++.so*
    # Package 'libgcc-s1'
    /usr/lib/*linux-gnu/libgcc_s.so*
)

# Architecture-specific packages
case "$(uname -m)" in
x86_64)
    paths_to_mirror+=(
        /usr/lib/*-linux-gnu/libmvec.so*
        /usr/lib/*-linux-gnu/ld-linux-x86-64.so*
        /usr/lib64/ld-linux-x86-64.so*
    )
;;
aarch64)
    paths_to_mirror+=(
        /usr/lib/ld-linux-aarch64.so*
        /usr/lib/*-linux-gnu/ld-linux-aarch64.so*
    )
;;
esac


for file in "${paths_to_mirror[@]}"; do
    if [[ -d "$file" ]]; then
        dir="${DEST_DIR}$(dirname $file)"
    else
        dir=$(dirname "${DEST_DIR}${file}")
    fi
    mkdir -p "$dir"
    cp -a "${file}" "$dir"
done
