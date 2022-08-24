FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="2.6.1-debian-11-r14" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/grafana-loki" \
      org.opencontainers.image.title="grafana-loki" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="2.6.1"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/grafana-loki-2.6.1-1-linux-amd64-debian-11.tar.gz && \
    echo "31f061f034030082825a8d726a70148b678c9094b4d5ef2238e82a14945de38f  /tmp/bitnami/pkg/cache/grafana-loki-2.6.1-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/grafana-loki-2.6.1-1-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/grafana-loki-2.6.1-1-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir -p /bitnami/grafana-loki/data /bitnami/grafana-loki/loki /bitnami/grafana-loki/wal && chmod -R g+rwX /bitnami/grafana-loki && ln -s  /bitnami/grafana-loki/loki /loki && ln -s /bitnami/grafana-loki/data /data && ln -s /bitnami/grafana-loki/wal /wal

ENV APP_VERSION="2.6.1" \
    BITNAMI_APP_NAME="grafana-loki" \
    PATH="/opt/bitnami/grafana-loki/bin:$PATH"

EXPOSE 3100

USER 1001
ENTRYPOINT [ "loki" ]
CMD [ "-config.file=/bitnami/grafana-loki/conf/loki.yaml" ]
