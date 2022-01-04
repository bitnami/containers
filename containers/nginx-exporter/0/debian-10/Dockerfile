FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/nginx-exporter-0.10.0-0-linux-amd64-debian-10.tar.gz && \
    echo "627e2a6fd8a15bdc214388567d5e529c9bda8ba52ebeb8111fba8024659e429f  /tmp/bitnami/pkg/cache/nginx-exporter-0.10.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/nginx-exporter-0.10.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/nginx-exporter-0.10.0-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami
RUN ln -sf /opt/bitnami/nginx-exporter/bin/nginx-prometheus-exporter /usr/bin/exporter

ENV BITNAMI_APP_NAME="nginx-exporter" \
    BITNAMI_IMAGE_VERSION="0.10.0-debian-10-r13" \
    PATH="/opt/bitnami/nginx-exporter/bin:$PATH"

EXPOSE 9113

WORKDIR /opt/bitnami/nginx-exporter
USER 1001
ENTRYPOINT [ "nginx-prometheus-exporter" ]
