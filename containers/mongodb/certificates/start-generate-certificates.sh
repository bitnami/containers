#!/bin/bash

docker run \
    -w /ssl \
    -v $(pwd):/ssl \
    --rm -it bitnami/minideb-extras-base:stretch /ssl/generate-certificates.sh