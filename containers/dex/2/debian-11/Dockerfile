FROM docker.io/bitnami/minideb:bullseye
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/dex-2.32.0-150-linux-amd64-debian-11.tar.gz && \
    echo "a7007573d20ec047124c84e6244186488834ced6cc6b2539102713af16e1c5c8  /tmp/bitnami/pkg/cache/dex-2.32.0-150-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/dex-2.32.0-150-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/dex-2.32.0-150-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN useradd -r -u 1001 -g root dex

ENV APP_VERSION="2.32.0" \
    BITNAMI_APP_NAME="dex" \
    DEX_FRONTEND_DIR="/opt/bitnami/dex/web" \
    PATH="/opt/bitnami/dex/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/dex/bin/dex" ]
