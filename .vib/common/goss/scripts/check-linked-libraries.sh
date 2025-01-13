#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

set -o errexit
set -o nounset
set -o pipefail

mapfile -t files < <( find "$BITNAMI_ROOT_DIR"/"$BITNAMI_APP_NAME" "$BITNAMI_ROOT_DIR"/common -type f -executable )

for file in "${files[@]}"; do
  if [[ -n $EXCLUDE_PATHS ]] && [[ "$file" =~ $EXCLUDE_PATHS ]]; then
    continue
  fi
  if ldd "$file" 2>&1 | grep -q "not a dynamic executable"; then
    continue
  fi
  if ldd "$file" | grep -c "not found"; then
    echo "missing linked libraries at $file"
    exit 1
  fi
done
