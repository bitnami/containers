# set defaults
export RABBITMQ_ULIMIT_NOFILES=${RABBITMQ_ULIMIT_NOFILES:-65536}

# apply resources limits
ulimit -n "${RABBITMQ_ULIMIT_NOFILES}"
