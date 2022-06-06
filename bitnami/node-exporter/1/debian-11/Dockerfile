FROM docker.io/bitnami/minideb:bullseye
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/node-exporter-1.3.1-0-linux-amd64-debian-11.tar.gz && \
    echo "d37f2e0711ec7e3255e214bb60b9cfd630d0b0d0959a90c8140181b0120628d5  /tmp/bitnami/pkg/cache/node-exporter-1.3.1-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/node-exporter-1.3.1-0-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/node-exporter-1.3.1-0-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="1.3.1" \
    BITNAMI_APP_NAME="node-exporter" \
    PATH="/opt/bitnami/node-exporter/bin:$PATH"

EXPOSE 9100

WORKDIR /opt/bitnami/node-exporter
USER 1001
ENTRYPOINT [ "/opt/bitnami/node-exporter/bin/node_exporter" ]
