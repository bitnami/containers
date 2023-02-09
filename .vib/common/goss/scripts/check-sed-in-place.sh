#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

mapfile -t files < <( find /bitnami "$BITNAMI_ROOT_DIR" -name '*.sh' )

for file in "${files[@]}"; do
  [[ $(grep -cE "sed -i|sed --in-place" "$file") -eq 0 ]] || exit 1
done
