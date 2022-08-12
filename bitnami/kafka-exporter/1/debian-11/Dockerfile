FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.4.2-debian-11-r26" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/kafka-exporter" \
      org.opencontainers.image.title="kafka-exporter" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.4.2"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/kafka-exporter-1.4.2-152-linux-amd64-debian-11.tar.gz && \
    echo "f0275d56165de48f2e10d51f535f6dc0050633e803e82e728e7ffd8e0a8bc320  /tmp/bitnami/pkg/cache/kafka-exporter-1.4.2-152-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/kafka-exporter-1.4.2-152-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/kafka-exporter-1.4.2-152-linux-amd64-debian-11.tar.gz
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
