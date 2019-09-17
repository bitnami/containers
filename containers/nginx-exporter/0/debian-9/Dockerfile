FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/nginx-exporter-0.4.2-1-linux-amd64-debian-9.tar.gz && \
    echo "c01eeb8d319ad1cb5b423f73afbb3112bed4675e2254aa7b8fe8dd703ce9e845  /tmp/bitnami/pkg/cache/nginx-exporter-0.4.2-1-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/nginx-exporter-0.4.2-1-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/nginx-exporter-0.4.2-1-linux-amd64-debian-9.tar.gz
RUN ln -sf /opt/bitnami/nginx-exporter/bin/nginx-prometheus-exporter /usr/bin/exporter

ENV BITNAMI_APP_NAME="nginx-exporter" \
    BITNAMI_IMAGE_VERSION="0.4.2-debian-9-r57" \
    PATH="/opt/bitnami/nginx-exporter/bin:$PATH"

EXPOSE 9113

WORKDIR /opt/bitnami/nginx-exporter
USER 1001
ENTRYPOINT [ "nginx-prometheus-exporter" ]
