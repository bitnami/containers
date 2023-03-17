#!/bin/bash

set -x

asset="mysql"
dirname=".vib/$asset"

jq '.context += {"runtime_parameters": "Y29tbWFuZDogWyJ0YWlsIiwgIi1mIiwgIi9kZXYvbnVsbCJd"}' $dirname/vib-verify.json | sponge $dirname/vib-verify.json
jq '.context += {"runtime_parameters": "Y29tbWFuZDogWyJ0YWlsIiwgIi1mIiwgIi9kZXYvbnVsbCJd"}' $dirname/vib-publish.json | sponge $dirname/vib-publish.json

jq --argjson gossAction "$(<goss.json)" '.phases.verify.actions += [$gossAction]' $dirname/vib-verify.json | sed "s/placeholder/$asset/g" | sponge $dirname/vib-verify.json
jq --argjson gossAction "$(<goss.json)" '.phases.verify.actions += [$gossAction]' $dirname/vib-publish.json | sed "s/placeholder/$asset/g" | sponge $dirname/vib-publish.json

cp -r goss/ $dirname
mv $dirname/goss/placeholder.yaml $dirname/goss/$asset.yaml

while IFS= read -r file; do

  sed -i "" "s/placeholder/$asset/g" $file

done < <(find $dirname/goss -name '*.yaml')

echo "Done"
