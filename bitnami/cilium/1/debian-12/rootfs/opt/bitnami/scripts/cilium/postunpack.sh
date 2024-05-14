#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libcilium.sh

# Load Cilium environment variables
. /opt/bitnami/scripts/cilium-env.sh

# Generate bash completion for Cilium & Hubble
cilium_bash_completion
