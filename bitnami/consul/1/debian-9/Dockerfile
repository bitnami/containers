FROM bitnami/minideb-extras:stretch-r162
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN bitnami-pkg unpack consul-1.2.3-1 --checksum f7fe7a52cfa48e465a4202612e9bf5d5141e8a3a86b86f21439fe19aa331a6e5

COPY rootfs /
ENV BITNAMI_APP_NAME="consul" \
    BITNAMI_IMAGE_VERSION="1.2.3-debian-9-r20" \
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

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
