FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.6.0-debian-11-r3" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/kafka-exporter" \
      org.opencontainers.image.title="kafka-exporter" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.6.0"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f kafka-exporter-1.6.0-1-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/kafka-exporter-1.6.0-1-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "990dc3a8b1d2f61a2830957f4572640aec0631035ffc77b68f89766a88c919b2  kafka-exporter-1.6.0-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf kafka-exporter-1.6.0-1-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf kafka-exporter-1.6.0-1-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="1.6.0" \
    BITNAMI_APP_NAME="kafka-exporter" \
    PATH="/opt/bitnami/kafka-exporter/bin:$PATH"

EXPOSE 9308

WORKDIR /opt/bitnami/kafka-exporter
USER 1001
ENTRYPOINT [ "kafka_exporter" ]
