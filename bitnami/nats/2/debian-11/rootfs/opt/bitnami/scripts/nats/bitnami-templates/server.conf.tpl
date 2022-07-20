# host/port to listen for client connections
listen: {{NATS_DEFAULT_BIND_ADDRESS}}:{{NATS_DEFAULT_CLIENT_PORT_NUMBER}}
# host/port for HTTP monitoring
http: {{NATS_DEFAULT_BIND_ADDRESS}}:{{NATS_DEFAULT_HTTP_PORT_NUMBER}}
# host/port for HTTPS monitoring
# https: {{NATS_DEFAULT_BIND_ADDRESS}}:{{NATS_DEFAULT_HTTPS_PORT_NUMBER}}

# Logging options
debug: false
log_file: "{{NATS_LOG_FILE}}"

# Pid file
pid_file: "{{NATS_PID_FILE}}"
{{#if enable_auth}}

# Authorization for client connections
authorization {
  timeout: 1
  {{#if token }}
  token: "{{NATS_TOKEN}}"
  {{else}}
  user: {{NATS_USERNAME}}
  password: "{{NATS_PASSWORD}}"
  {{/if}}
}
{{/if}}
{{#if enable_tls}}

tls {
  cert_file:  "{{NATS_CONF_DIR}}/certs/{{NATS_TLS_CRT_FILENAME}}"
  key_file:   "{{NATS_CONF_DIR}}/certs/{{NATS_TLS_KEY_FILENAME}}"
  timeout:    2
}
{{/if}}
{{#if enable_cluster}}

# Clustering multiple servers together
cluster {
  listen: {{NATS_BIND_ADDRESS}}:{{NATS_CLUSTER_PORT_NUMBER}}
  {{#if enable_auth}}
  # Authorization for route connections
  authorization {
    timeout: 2
    {{#if cluster_token }}
    token: "{{NATS_CLUSTER_TOKEN}}"
    {{else}}
    user: {{NATS_CLUSTER_USERNAME}}
    password: "{{NATS_CLUSTER_PASSWORD}}"
    {{/if}}
  }
  {{/if}}
  {{#if cluster_routes}}
  # Routes are actively solicited and connected to from this server.
  # Other servers can connect to us if they supply the correct credentials
  # in their routes definitions from above
  routes = [
      {{cluster_routes}}
  ]
  {{/if}}
}
{{/if}}
