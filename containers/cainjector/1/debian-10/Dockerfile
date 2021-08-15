FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/cainjector-1.5.0-0-linux-amd64-debian-10.tar.gz && \
    echo "3f16decd5479a5717ead54d039975ba688c863edee494207153783b6e6e1c9ff  /tmp/bitnami/pkg/cache/cainjector-1.5.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/cainjector-1.5.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/cainjector-1.5.0-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="cainjector" \
    BITNAMI_IMAGE_VERSION="1.5.0-debian-10-r4" \
    PATH="/opt/bitnami/cainjector/bin:$PATH"

WORKDIR /opt/bitnami/cainjector
USER 1001
ENTRYPOINT [ "/opt/bitnami/cainjector/bin/cainjector" ]
