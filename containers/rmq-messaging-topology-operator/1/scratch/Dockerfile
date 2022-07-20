FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates gzip tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/rmq-messaging-topology-operator-1.7.1-0-linux-amd64-debian-11.tar.gz && \
    echo "531a69d8283511cca1b354846289db487b8e24f0b552c6767d970d1317b470c1  /tmp/bitnami/pkg/cache/rmq-messaging-topology-operator-1.7.1-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/rmq-messaging-topology-operator-1.7.1-0-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/rmq-messaging-topology-operator-1.7.1-0-linux-amd64-debian-11.tar.gz

######

FROM scratch

COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/rmq-messaging-topology-operator/bin/manager /manager

USER 1001

ENTRYPOINT [ "/manager" ]
