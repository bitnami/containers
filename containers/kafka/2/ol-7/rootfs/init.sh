##
## @brief     Helper function to show an error when KAFKA_LISTENERS does not configure a secure listener
## param $1   Input name
##
plaintext_listener_error() {
    error "The $1 environment variable does not set a secure listener. Set the environment variable ALLOW_PLAINTEXT_LISTENER=yes to allow the container to be started with a plaintext listener. This is recommended only for development."
  exit 1
}

##
## @brief     Helper function to show a warning when the ALLOW_PLAINTEXT_LISTENER flag is enabled
##
plaintext_listener_enabled_warn() {
  warn "You set the environment variable ALLOW_PLAINTEXT_LISTENER=${ALLOW_PLAINTEXT_LISTENER}. For safety reasons, do not use this flag in a production environment."
}


# Validate passwords
if [[ "$ALLOW_PLAINTEXT_LISTENER" =~ ^(yes|Yes|YES)$ ]]; then
    plaintext_listener_enabled_warn
elif [[ ! "$KAFKA_LISTENERS" =~ SASL_SSL ]]; then
    plaintext_listener_error KAFKA_LISTENERS
fi
