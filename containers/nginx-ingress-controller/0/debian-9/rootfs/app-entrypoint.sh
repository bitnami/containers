#!/bin/bash

exec authbind --deep nginx-ingress-controller "$@"
