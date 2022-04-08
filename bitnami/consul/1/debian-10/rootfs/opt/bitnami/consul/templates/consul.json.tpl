{
    "node_name": "{{CONSUL_NODE_NAME}}",
    "datacenter": "{{CONSUL_DATACENTER}}",
    "domain": "{{CONSUL_DOMAIN}}",
    "data_dir": "{{CONSUL_DATA_DIR}}",
    "pid_file": "{{CONSUL_PID_FILE}}",
    "ui": {{CONSUL_ENABLE_UI}},
    "bootstrap_expect": {{CONSUL_BOOTSTRAP_EXPECT}},
    "performance": {
      "raft_multiplier": {{CONSUL_RAFT_MULTIPLIER}}
    },
    "addresses": {
        "http": "{{CONSUL_CLIENT_LAN_ADDRESS}}"
    },
    "retry_join": ["{{CONSUL_RETRY_JOIN_ADDRESS}}"],
    "retry_join_wan": ["{{CONSUL_RETRY_JOIN_WAN_ADDRESS}}"],
    "ports": {
        "http": {{CONSUL_HTTP_PORT_NUMBER}},
        "dns": {{CONSUL_DNS_PORT_NUMBER}},
        "serf_lan": {{CONSUL_SERF_LAN_PORT_NUMBER}},
        "server": {{CONSUL_RPC_PORT_NUMBER}}
    },
    "serf_lan": "{{CONSUL_SERF_LAN_ADDRESS}}"
}
