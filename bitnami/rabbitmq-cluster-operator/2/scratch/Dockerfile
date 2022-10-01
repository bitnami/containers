FROM bitnami/minideb:bullseye as builder

ARG TARGETARCH

ENV OS_ARCH="${TARGETARCH:-amd64}"

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates curl
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f rabbitmq-cluster-operator-2.0.0-0-linux-${OS_ARCH}-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/rabbitmq-cluster-operator-2.0.0-0-linux-${OS_ARCH}-debian-11.tar.gz -O ; \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/rabbitmq-cluster-operator-2.0.0-0-linux-${OS_ARCH}-debian-11.tar.gz.sha256 -O ; \
    fi && \
    sha256sum -c rabbitmq-cluster-operator-2.0.0-0-linux-${OS_ARCH}-debian-11.tar.gz.sha256 && \
    tar -zxf rabbitmq-cluster-operator-2.0.0-0-linux-${OS_ARCH}-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf rabbitmq-cluster-operator-2.0.0-0-linux-${OS_ARCH}-debian-11.tar.gz rabbitmq-cluster-operator-2.0.0-0-linux-${OS_ARCH}-debian-11.tar.gz.sha256

######

FROM scratch

ARG TARGETARCH

ENV OS_ARCH="${TARGETARCH:-amd64}"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="2.0.0-scratch-r2" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/rabbitmq-cluster-operator" \
      org.opencontainers.image.title="rabbitmq-cluster-operator" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="2.0.0"

COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/rabbitmq-cluster-operator/bin/manager /manager

USER 1001

ENTRYPOINT [ "/manager" ]
