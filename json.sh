#!/bin/bash

# set -x

while IFS= read -r file; do

  jq . $file | sponge $file

done < <(find . -name 'vib-*.json')

echo "Done"
