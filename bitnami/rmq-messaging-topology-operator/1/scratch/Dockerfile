FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates gzip tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/rmq-messaging-topology-operator-1.8.0-0-linux-amd64-debian-11.tar.gz && \
    echo "1f8a970a820a7ddfe33b8a381fb921ba931afaf135dbd9149cd8df2d10279d89  /tmp/bitnami/pkg/cache/rmq-messaging-topology-operator-1.8.0-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/rmq-messaging-topology-operator-1.8.0-0-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/rmq-messaging-topology-operator-1.8.0-0-linux-amd64-debian-11.tar.gz

######

FROM scratch

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.8.0-scratch-r0" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/rmq-messaging-topology-operator" \
      org.opencontainers.image.title="rmq-messaging-topology-operator" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.8.0"
COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/rmq-messaging-topology-operator/bin/manager /manager

USER 1001

ENTRYPOINT [ "/manager" ]
