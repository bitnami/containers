FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/cert-manager-1.5.0-0-linux-amd64-debian-10.tar.gz && \
    echo "6e4d5a88af2f9472c734653bee5c0d96f7705140a37c959d59cb29d0e27ec934  /tmp/bitnami/pkg/cache/cert-manager-1.5.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/cert-manager-1.5.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/cert-manager-1.5.0-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="cert-manager" \
    BITNAMI_IMAGE_VERSION="1.5.0-debian-10-r1" \
    PATH="/opt/bitnami/cert-manager/bin:$PATH"

WORKDIR /opt/bitnami/cert-manager
USER 1001
ENTRYPOINT [ "/opt/bitnami/cert-manager/bin/cert-manager" ]
