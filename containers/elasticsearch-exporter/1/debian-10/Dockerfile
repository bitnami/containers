FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/elasticsearch-exporter-1.3.0-2-linux-amd64-debian-10.tar.gz && \
    echo "fbfeb02148ad7d9f723ee81dbe2ed2dbb9d3e93b4371545b395dcf784ef48a4f  /tmp/bitnami/pkg/cache/elasticsearch-exporter-1.3.0-2-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/elasticsearch-exporter-1.3.0-2-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/elasticsearch-exporter-1.3.0-2-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="elasticsearch-exporter" \
    BITNAMI_IMAGE_VERSION="1.3.0-debian-10-r87" \
    PATH="/opt/bitnami/elasticsearch-exporter/bin:$PATH"

EXPOSE 9114

WORKDIR /opt/bitnami/elasticsearch-exporter
USER 1001
ENTRYPOINT [ "/opt/bitnami/elasticsearch-exporter/bin/elasticsearch_exporter" ]
