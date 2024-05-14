#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libtensorflow-serving.sh

# Load tensorflow environment variables
. /opt/bitnami/scripts/tensorflowserving-env.sh

# Ensure tensorflow environment variables are valid
tensorflow_serving_validate

# Ensure tensorflow is initialized
tensorflow_serving_initialize
