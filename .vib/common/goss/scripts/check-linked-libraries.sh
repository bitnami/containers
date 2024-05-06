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
  [[ $(ldd "$file" | grep -c "not found") -eq 0 ]] || exit 1
done
