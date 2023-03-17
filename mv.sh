#!/bin/bash

# set -x

dirname=".vib/$TEST_ASSET/"

jq '.context += {"runtime_parameters": "Y29tbWFuZDogWyJ0YWlsIiwgIi1mIiwgIi9kZXYvbnVsbCJd"}' $dirname/vib-verify.json | sponge $dirname/vib-verify.json
jq '.context += {"runtime_parameters": "Y29tbWFuZDogWyJ0YWlsIiwgIi1mIiwgIi9kZXYvbnVsbCJd"}' $dirname/vib-publish.json | sponge $dirname/vib-publish.json

jq --argjson gossAction "$(<goss.json)" '.phases.verify.actions += [$gossAction]' $dirname/vib-verify.json | sed "s/placeholder/$asset/g" | sponge $dirname/vib-verify.json
jq --argjson gossAction "$(<goss.json)" '.phases.verify.actions += [$gossAction]' $dirname/vib-publish.json | sed "s/placeholder/$TEST_ASSET/g" | sponge $dirname/vib-publish.json
  
echo "Done"
