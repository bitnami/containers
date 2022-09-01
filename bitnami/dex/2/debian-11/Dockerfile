FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="2.33.0-debian-11-r12" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/dex" \
      org.opencontainers.image.title="dex" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="2.33.0"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f dex-2.33.0-2-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/dex-2.33.0-2-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "8aafef1cf3a7e51708a23ab6593cb4c02060faaf2fd6672f24dfe30ea22fc1ab  dex-2.33.0-2-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf dex-2.33.0-2-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf dex-2.33.0-2-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN useradd -r -u 1001 -g root dex

ENV APP_VERSION="2.33.0" \
    BITNAMI_APP_NAME="dex" \
    DEX_FRONTEND_DIR="/opt/bitnami/dex/web" \
    PATH="/opt/bitnami/dex/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/dex/bin/dex" ]
