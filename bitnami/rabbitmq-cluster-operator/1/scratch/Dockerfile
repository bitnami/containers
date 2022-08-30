FROM bitnami/minideb:bullseye as builder

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f rabbitmq-cluster-operator-1.14.0-3-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/rabbitmq-cluster-operator-1.14.0-3-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "f6148b1ae97eb22eae7d18c8b8c1e9b0e2aab3e730ebdd945e9ee6bfd7c44f1f  rabbitmq-cluster-operator-1.14.0-3-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf rabbitmq-cluster-operator-1.14.0-3-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --wildcards '*/files' && \
    rm -rf rabbitmq-cluster-operator-1.14.0-3-linux-amd64-debian-11.tar.gz

######

FROM scratch

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.14.0-scratch-r6" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/rabbitmq-cluster-operator" \
      org.opencontainers.image.title="rabbitmq-cluster-operator" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.14.0"
COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/rabbitmq-cluster-operator/bin/manager /manager

USER 1001

ENTRYPOINT [ "/manager" ]
