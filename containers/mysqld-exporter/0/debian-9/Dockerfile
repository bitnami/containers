FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/mysqld-exporter-0.12.0-0-linux-amd64-debian-9.tar.gz && \
    echo "7e4a404f449d25ad19b3d5066b5e4ffb172257676bfe56ee550326052826dd97  /tmp/bitnami/pkg/cache/mysqld-exporter-0.12.0-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/mysqld-exporter-0.12.0-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/mysqld-exporter-0.12.0-0-linux-amd64-debian-9.tar.gz

ENV BITNAMI_APP_NAME="mysqld-exporter" \
    BITNAMI_IMAGE_VERSION="0.12.0-debian-9-r1" \
    PATH="/opt/bitnami/mysqld-exporter/bin:$PATH"

EXPOSE 9104

WORKDIR /opt/bitnami/mysqld-exporter
USER 1001
ENTRYPOINT [ "mysqld_exporter" ]
