# Set defaults
export RABBITMQ_ULIMIT_NOFILES=${RABBITMQ_ULIMIT_NOFILES:-65536}

# Apply resources limits
ulimit -n "${RABBITMQ_ULIMIT_NOFILES}"
