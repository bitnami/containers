FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates libc6 wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/nats-exporter-0.5.0-0-linux-amd64-debian-9.tar.gz && \
    echo "3a448cf77493d9d233844c1eada90df4d787f42aec6fa0ec17bda1b4a149caea  /tmp/bitnami/pkg/cache/nats-exporter-0.5.0-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/nats-exporter-0.5.0-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/nats-exporter-0.5.0-0-linux-amd64-debian-9.tar.gz

ENV BITNAMI_APP_NAME="nats-exporter" \
    BITNAMI_IMAGE_VERSION="0.5.0-debian-9-r11" \
    PATH="/opt/bitnami/nats-exporter/bin:$PATH"

EXPOSE 7777

WORKDIR /opt/bitnami/nats-exporter
USER 1001
ENTRYPOINT [ "prometheus-nats-exporter" ]
