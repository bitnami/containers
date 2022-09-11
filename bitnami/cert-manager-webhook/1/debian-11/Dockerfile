FROM docker.io/bitnami/minideb:bullseye

ARG TARGETARCH

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.9.1-debian-11-r16" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/cert-manager-webhook" \
      org.opencontainers.image.title="cert-manager-webhook" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.9.1"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f cert-manager-webhook-1.9.1-2-linux-${OS_ARCH}-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/cert-manager-webhook-1.9.1-2-linux-${OS_ARCH}-debian-11.tar.gz -O ; \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/cert-manager-webhook-1.9.1-2-linux-${OS_ARCH}-debian-11.tar.gz.sha256 -O ; \
    fi && \
    sha256sum -c cert-manager-webhook-1.9.1-2-linux-${OS_ARCH}-debian-11.tar.gz.sha256 && \
    tar -zxf cert-manager-webhook-1.9.1-2-linux-${OS_ARCH}-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf cert-manager-webhook-1.9.1-2-linux-${OS_ARCH}-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="1.9.1" \
    BITNAMI_APP_NAME="cert-manager-webhook" \
    PATH="/opt/bitnami/cert-manager-webhook/bin:$PATH"

WORKDIR /opt/bitnami/cert-manager-webhook
USER 1001
ENTRYPOINT [ "/opt/bitnami/cert-manager-webhook/bin/cert-manager-webhook" ]
