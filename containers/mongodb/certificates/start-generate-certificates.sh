#!/bin/bash

docker run \
    -w /ssl \
    -v $(pwd):/ssl \
    --rm -it ubuntu:18.04 /ssl/generate-certificates.sh