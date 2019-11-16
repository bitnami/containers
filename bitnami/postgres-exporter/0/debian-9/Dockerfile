FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/postgres-exporter-0.7.0-0-linux-amd64-debian-9.tar.gz && \
    echo "ff58defd2321c0e6b41edc37d7facdf226aef1e6cd3b961f7476699fb0706806  /tmp/bitnami/pkg/cache/postgres-exporter-0.7.0-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/postgres-exporter-0.7.0-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/postgres-exporter-0.7.0-0-linux-amd64-debian-9.tar.gz

ENV BITNAMI_APP_NAME="postgres-exporter" \
    BITNAMI_IMAGE_VERSION="0.7.0-debian-9-r14" \
    PATH="/opt/bitnami/postgres-exporter/bin:$PATH"

EXPOSE 9187

WORKDIR /opt/bitnami/postgres-exporter
USER 1001
ENTRYPOINT [ "postgres_exporter" ]
