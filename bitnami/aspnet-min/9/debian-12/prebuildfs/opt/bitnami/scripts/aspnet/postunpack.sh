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
    # Package 'libicu72'
    /usr/lib/*-linux-gnu/libicudata.so*
    /usr/lib/*-linux-gnu/libicui18n.so*
    /usr/lib/*-linux-gnu/libicutest.so*
    /usr/lib/*-linux-gnu/libicutu.so*
    /usr/lib/*-linux-gnu/libicuio.so*
    /usr/lib/*-linux-gnu/libicuuc.so*
)

for file in "${paths_to_mirror[@]}"; do
    if [[ -d "$file" ]]; then
        dir="${DEST_DIR}$(dirname $file)"
    else
        dir=$(dirname "${DEST_DIR}${file}")
    fi
    mkdir -p "$dir"
    cp -a "${file}" "$dir"
done