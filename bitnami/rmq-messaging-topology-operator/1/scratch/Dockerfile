FROM bitnami/minideb:bullseye as builder

ARG TARGETARCH

ENV OS_ARCH="${TARGETARCH:-amd64}"

COPY prebuildfs /

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f rmq-messaging-topology-operator-1.8.0-1-linux-${OS_ARCH}-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/rmq-messaging-topology-operator-1.8.0-1-linux-${OS_ARCH}-debian-11.tar.gz -O ; \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/rmq-messaging-topology-operator-1.8.0-1-linux-${OS_ARCH}-debian-11.tar.gz.sha256 -O ; \
    fi && \
    sha256sum -c rmq-messaging-topology-operator-1.8.0-1-linux-${OS_ARCH}-debian-11.tar.gz.sha256 && \
    tar -zxf rmq-messaging-topology-operator-1.8.0-1-linux-${OS_ARCH}-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf rmq-messaging-topology-operator-1.8.0-1-linux-${OS_ARCH}-debian-11.tar.gz

######

FROM scratch

ARG TARGETARCH

ENV OS_ARCH="${TARGETARCH:-amd64}"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.8.0-scratch-r2" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/rmq-messaging-topology-operator" \
      org.opencontainers.image.title="rmq-messaging-topology-operator" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.8.0"

COPY prebuildfs /
COPY rootfs /
COPY --from=builder /opt/bitnami/rmq-messaging-topology-operator/bin/manager /manager

USER 1001

ENTRYPOINT [ "/manager" ]
