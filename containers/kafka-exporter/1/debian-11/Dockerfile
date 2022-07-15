FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kafka-exporter-1.4.2-151-linux-amd64-debian-11.tar.gz && \
    echo "f0930fc8311f7506e0a8a51f3ad552071fe0165286e0c75985f6ab4cc41dfe89  /tmp/bitnami/pkg/cache/kafka-exporter-1.4.2-151-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kafka-exporter-1.4.2-151-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kafka-exporter-1.4.2-151-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="1.4.2" \
    BITNAMI_APP_NAME="kafka-exporter" \
    PATH="/opt/bitnami/kafka-exporter/bin:$PATH"

EXPOSE 9308

WORKDIR /opt/bitnami/kafka-exporter
USER 1001
ENTRYPOINT [ "kafka_exporter" ]
