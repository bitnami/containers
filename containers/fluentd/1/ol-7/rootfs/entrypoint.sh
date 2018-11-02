#!/bin/bash

FLUENTD_CONF=${FLUENTD_CONF:-"fluentd.conf"}
CONF_FILE="/opt/bitnami/fluentd/conf/${FLUENTD_CONF}"

if [[ ! -e "$CONF_FILE" ]]; then
    echo "==> Writing config file..."
    cat > "$CONF_FILE" << EOF
<source>
  @type  forward
  @id    input1
  @label @mainstream
  port  24224
</source>

<filter **>
  @type stdout
</filter>

<label @mainstream>
  <match docker.**>
    @type file
    @id   output_docker1
    path         /opt/bitnami/fluentd/logs/docker.*.log
    symlink_path /opt/bitnami/fluentd/logs/docker.log
    append       true
    time_slice_format %Y%m%d
    time_slice_wait   1m
    time_format       %Y%m%dT%H%M%S%z
  </match>
  <match **>
    @type file
    @id   output1
    path         /opt/bitnami/fluentd/logs/data.*.log
    symlink_path /opt/bitnami/fluentd/logs/data.log
    append       true
    time_slice_format %Y%m%d
    time_slice_wait   10m
    time_format       %Y%m%dT%H%M%S%z
  </match>
</label>

# Include config files in the ./config.d directory
@include config.d/*.conf
EOF
else
    echo "==> Detected config file. It would be used instead of creating one."
fi

eval "$@"
