FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/dex-2.30.2-1-linux-amd64-debian-10.tar.gz && \
    echo "d13958e462df2908efd3db0693ddea10efc8b4b8e1246bc6863378c141e9ce0f  /tmp/bitnami/pkg/cache/dex-2.30.2-1-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/dex-2.30.2-1-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/dex-2.30.2-1-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN useradd -r -u 1001 -g root dex

ENV BITNAMI_APP_NAME="dex" \
    BITNAMI_IMAGE_VERSION="2.30.2-debian-10-r60" \
    DEX_FRONTEND_DIR="/opt/bitnami/dex/web" \
    PATH="/opt/bitnami/dex/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/dex/bin/dex" ]
