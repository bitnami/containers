FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/mongodb-exporter-0.8.0-0-linux-amd64-debian-9.tar.gz && \
    echo "28b42fa44b7e16b5f5696f80cacb00b65881a955070ce057f423633072b42598  /tmp/bitnami/pkg/cache/mongodb-exporter-0.8.0-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/mongodb-exporter-0.8.0-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/mongodb-exporter-0.8.0-0-linux-amd64-debian-9.tar.gz
RUN ln -sf /opt/bitnami/mongodb-exporter/bin/mongodb_exporter /bin/mongodb_exporter

ENV BITNAMI_APP_NAME="mongodb-exporter" \
    BITNAMI_IMAGE_VERSION="0.8.0-debian-9-r3" \
    PATH="/opt/bitnami/mongodb-exporter/bin:$PATH"

EXPOSE 9216

WORKDIR /opt/bitnami/mongodb-exporter
USER 1001
ENTRYPOINT [ "mongodb_exporter" ]
