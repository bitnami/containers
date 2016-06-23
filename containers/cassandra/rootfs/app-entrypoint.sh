#!/bin/bash
set -e

function initialize {
    # Package can be "installed" or "unpacked"
    status=`harpoon inspect $1`
    if [[ "$status" == *'"lifecycle": "unpacked"'* ]]; then
        # Clean up inputs
        inputs=""
        if [[ -f /$1-inputs.json ]]; then
            inputs=--inputs-file=/$1-inputs.json
        fi
        harpoon initialize $1 $inputs
    fi
}

# Set default values
export CASSANDRA_CLUSTER_NAME=${CASSANDRA_CLUSTER_NAME:-"My Cluster"}
export CASSANDRA_TRANSPORT_PORT=${CASSANDRA_TRANSPORT_PORT:-"7000"}
export CASSANDRA_SSL_TRANSPORT_PORT=${CASSANDRA_SSL_TRANSPORT_PORT:-"7001"}
export CASSANDRA_JMX_PORT=${CASSANDRA_JMX_PORT:-"7199"}
export CASSANDRA_CQL_PORT=${CASSANDRA_CQL_PORT:-"9042"}
export CASSANDRA_RPC_PORT=${CASSANDRA_RPC_PORT:-"9160"}
export CASSANDRA_USER=${CASSANDRA_USER:-"cassandra"}
export CASSANDRA_PASSWORD=${CASSANDRA_PASSWORD:-"cassandra"}
export CASSANDRA_ENDPOINT_SNITCH=${CASSANDRA_ENDPOINT_SNITCH:-"SimpleSnitch"}

if [[ "$1" == "harpoon" && "$2" == "start" ]] ||  [[ "$1" == "/init.sh" ]]; then
   initialize cassandra
   echo "Starting application ..."
fi

exec /entrypoint.sh "$@"
