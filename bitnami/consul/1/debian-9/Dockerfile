FROM bitnami/minideb-extras:stretch-r92
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN bitnami-pkg unpack consul-1.2.1-2 --checksum bfb6b0f2724c988ada2a3da0dad0ba4b36c9a162d3bef2d6cbb8e3f3ea2ba493

COPY rootfs /
ENV BITNAMI_APP_NAME="consul" \
    BITNAMI_IMAGE_VERSION="1.2.1-debian-9-r19" \
    CONSUL_BOOTSTRAP_EXPECT="1" \
    CONSUL_CLIENT_LAN_ADDRESS="0.0.0.0" \
    CONSUL_DATACENTER="dc1" \
    CONSUL_DISABLE_KEYRING_FILE="false" \
    CONSUL_DNS_PORT_NUMBER="8600" \
    CONSUL_DOMAIN="consul" \
    CONSUL_GOSSIP_ENCRYPTION="no" \
    CONSUL_GOSSIP_ENCRYPTION_KEY="" \
    CONSUL_HTTP_PORT_NUMBER="8500" \
    CONSUL_LOCAL_CONFIG="" \
    CONSUL_RAFT_MULTIPLIER="1" \
    CONSUL_RETRY_JOIN="127.0.0.1" \
    CONSUL_RPC_PORT_NUMBER="8300" \
    CONSUL_SERF_LAN_ADDRESS="0.0.0.0" \
    CONSUL_SERF_LAN_PORT_NUMBER="8301" \
    CONSUL_SERVER_MODE="server" \
    CONSUL_UI="true" \
    PATH="/opt/bitnami/consul/bin:$PATH"

EXPOSE 8300 8301 8500 8600

EXPOSE 8301/udp 8600/udp

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
