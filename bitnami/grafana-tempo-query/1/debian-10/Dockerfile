FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/jaeger-query-1.30.0-1-linux-amd64-debian-10.tar.gz && \
    echo "d59a219c45f7d441e85696ee46e0aa4cc39326173cf83d83d93b604eb6c3a44a  /tmp/bitnami/pkg/cache/jaeger-query-1.30.0-1-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/jaeger-query-1.30.0-1-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/jaeger-query-1.30.0-1-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/grafana-tempo-query-1.2.1-2-linux-amd64-debian-10.tar.gz && \
    echo "aad0d7fd2b472fd5b489890041cab3e28a1b04d41c28d3cece8f7d138e3b28b3  /tmp/bitnami/pkg/cache/grafana-tempo-query-1.2.1-2-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/grafana-tempo-query-1.2.1-2-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/grafana-tempo-query-1.2.1-2-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="grafana-tempo-query" \
    BITNAMI_IMAGE_VERSION="1.2.1-debian-10-r63" \
    GRPC_STORAGE_PLUGIN_BINARY="/opt/bitnami/grafana-tempo-query/bin/tempo-query" \
    PATH="/opt/bitnami/jaeger-query/bin:/opt/bitnami/grafana-tempo-query/bin:$PATH" \
    SPAN_STORAGE_TYPE="grpc-plugin"

USER 1001
ENTRYPOINT [ "query" ]
CMD [ "--grpc-storage-plugin.configuration-file=/bitnami/grafana-tempo/conf/tempo-query.yaml" ]
