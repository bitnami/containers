#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

mapfile -t files < <( find "$BITNAMI_ROOT_DIR"/"$BITNAMI_APP_NAME" "$BITNAMI_ROOT_DIR"/common -type f -executable )

for file in "${files[@]}"; do
  if [[ -n $PATHS_TO_EXCLUDE ]] && [[ "$file" =~ $PATHS_TO_EXCLUDE ]]; then
    continue
  fi
  [[ $(ldd "$file" | grep -c "not found") -eq 0 ]] || exit 1
done
