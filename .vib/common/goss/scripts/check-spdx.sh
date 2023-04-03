#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

mapfile -t files < <( find /bitnami "$BITNAMI_ROOT_DIR" -type f -name '*.spdx' )

[[ ${#files[@]} -gt 0 ]]
