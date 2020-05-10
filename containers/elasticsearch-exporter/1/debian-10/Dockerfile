FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/elasticsearch-exporter-1.1.0-0-linux-amd64-debian-10.tar.gz && \
    echo "8c3777e2fa27a93e167bb5770f6d536a360c480028c776a76511ffe8bbf4f3c1  /tmp/bitnami/pkg/cache/elasticsearch-exporter-1.1.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/elasticsearch-exporter-1.1.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/elasticsearch-exporter-1.1.0-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

ENV BITNAMI_APP_NAME="elasticsearch-exporter" \
    BITNAMI_IMAGE_VERSION="1.1.0-debian-10-r106" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux" \
    PATH="/opt/bitnami/elasticsearch-exporter/bin:$PATH"

EXPOSE 9114

WORKDIR /opt/bitnami/elasticsearch-exporter
USER 1001
ENTRYPOINT [ "/opt/bitnami/elasticsearch-exporter/bin/elasticsearch_exporter" ]
