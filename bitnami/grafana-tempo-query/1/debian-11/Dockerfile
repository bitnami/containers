FROM docker.io/bitnami/minideb:bullseye

ARG TARGETARCH

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.5.0-debian-11-r7" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/grafana-tempo-query" \
      org.opencontainers.image.title="grafana-tempo-query" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.5.0"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f jaeger-query-1.37.0-2-linux-${OS_ARCH}-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/jaeger-query-1.37.0-2-linux-${OS_ARCH}-debian-11.tar.gz -O ; \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/jaeger-query-1.37.0-2-linux-${OS_ARCH}-debian-11.tar.gz.sha256 -O ; \
    fi && \
    sha256sum -c jaeger-query-1.37.0-2-linux-${OS_ARCH}-debian-11.tar.gz.sha256 && \
    tar -zxf jaeger-query-1.37.0-2-linux-${OS_ARCH}-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf jaeger-query-1.37.0-2-linux-${OS_ARCH}-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f grafana-tempo-query-1.5.0-1-linux-${OS_ARCH}-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/grafana-tempo-query-1.5.0-1-linux-${OS_ARCH}-debian-11.tar.gz -O ; \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/grafana-tempo-query-1.5.0-1-linux-${OS_ARCH}-debian-11.tar.gz.sha256 -O ; \
    fi && \
    sha256sum -c grafana-tempo-query-1.5.0-1-linux-${OS_ARCH}-debian-11.tar.gz.sha256 && \
    tar -zxf grafana-tempo-query-1.5.0-1-linux-${OS_ARCH}-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf grafana-tempo-query-1.5.0-1-linux-${OS_ARCH}-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="1.5.0" \
    BITNAMI_APP_NAME="grafana-tempo-query" \
    GRPC_STORAGE_PLUGIN_BINARY="/opt/bitnami/grafana-tempo-query/bin/tempo-query" \
    PATH="/opt/bitnami/jaeger-query/bin:/opt/bitnami/grafana-tempo-query/bin:$PATH" \
    SPAN_STORAGE_TYPE="grpc-plugin"

USER 1001
ENTRYPOINT [ "query" ]
CMD [ "--grpc-storage-plugin.configuration-file=/bitnami/grafana-tempo/conf/tempo-query.yaml" ]
