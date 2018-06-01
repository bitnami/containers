#!/bin/bash

CONF_FILE='/opt/bitnami/kubewatch/.kubewatch.yaml';

if [ ! -e ${CONF_FILE} ]; then
    echo "==> Writing config file..."
    cat > ${CONF_FILE} << EOF
handler:
  slack:
    token: "${KW_SLACK_TOKEN}"
    channel: "${KW_SLACK_CHANNEL}"
  hipchat:
    token: "${KW_HIPCHAT_TOKEN}"
    room: "${KW_HIPCHAT_ROOM}"
    url: "${KW_HIPCHAT_URL}"
  mattermost:
    channel: "${KW_MATTERMOST_CHANNEL}"
    url: "${KW_MATTERMOST_URL}"
    username: "${KW_MATTERMOST_USERNAME}"
  flock:
    url: "${KW_FLOCK_URL}"
  webhook:
    url: "${KW_WEBHOOK_URL}"
resource:
  deployment: true
  replicationcontroller: false
  replicaset: false
  daemonset: false
  services: true
  pod: true
  job: false
  persistentvolume: false
  namespace: true
  secret: false
  ingress: false
EOF
else
    echo "==> Config file exists..."
fi




exec kubewatch "$@"
