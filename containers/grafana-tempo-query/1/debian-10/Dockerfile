FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/jaeger-query-1.23.0-0-linux-amd64-debian-10.tar.gz && \
    echo "8d60eed674944ab6f278c09584b83191bcea0b1f59379de6cf6ead616eea23c6  /tmp/bitnami/pkg/cache/jaeger-query-1.23.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/jaeger-query-1.23.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/jaeger-query-1.23.0-0-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/grafana-tempo-query-1.0.1-0-linux-amd64-debian-10.tar.gz && \
    echo "c48ed5478b35ed8bebf0a870c6b68d9c7ac47b77e0f752d27ecea997a951bcc2  /tmp/bitnami/pkg/cache/grafana-tempo-query-1.0.1-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/grafana-tempo-query-1.0.1-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/grafana-tempo-query-1.0.1-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="grafana-tempo-query" \
    BITNAMI_IMAGE_VERSION="1.0.1-debian-10-r4" \
    GRPC_STORAGE_PLUGIN_BINARY="/opt/bitnami/grafana-tempo-query/bin/tempo-query" \
    PATH="/opt/bitnami/jaeger-query/bin:/opt/bitnami/grafana-tempo-query/bin:$PATH" \
    SPAN_STORAGE_TYPE="grpc-plugin"

USER 1001
ENTRYPOINT [ "query" ]
CMD [ "--grpc-storage-plugin.configuration-file=/bitnami/grafana-tempo/conf/tempo-query.yaml" ]
