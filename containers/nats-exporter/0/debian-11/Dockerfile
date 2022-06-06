FROM docker.io/bitnami/minideb:bullseye
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/nats-exporter-0.9.3-0-linux-amd64-debian-11.tar.gz && \
    echo "49620b59e8aad5de0c778782ac81035f92cf3ce323748760bc6904a847fae91b  /tmp/bitnami/pkg/cache/nats-exporter-0.9.3-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/nats-exporter-0.9.3-0-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/nats-exporter-0.9.3-0-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="0.9.3" \
    BITNAMI_APP_NAME="nats-exporter" \
    PATH="/opt/bitnami/nats-exporter/bin:$PATH"

EXPOSE 7777

WORKDIR /opt/bitnami/nats-exporter
USER 1001
ENTRYPOINT [ "prometheus-nats-exporter" ]
