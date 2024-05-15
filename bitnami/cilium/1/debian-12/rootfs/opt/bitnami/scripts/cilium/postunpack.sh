#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libcilium.sh
. /opt/bitnami/scripts/libos.sh

# Load Cilium environment variables
. /opt/bitnami/scripts/cilium-env.sh

# Photon does not provide the bash-completion package
if [[ "$(get_os_metadata --id)" != "photon" ]]; then
    # Generate bash completion for Cilium & Hubble
    cilium_bash_completion
fi
