FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/grafana-loki-2.6.0-1-linux-amd64-debian-11.tar.gz && \
    echo "3b9433991a3967323bd261f2b3c16f7b4f1d39b1d5682b71003229b578596d85  /tmp/bitnami/pkg/cache/grafana-loki-2.6.0-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/grafana-loki-2.6.0-1-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/grafana-loki-2.6.0-1-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir -p /bitnami/grafana-loki/data /bitnami/grafana-loki/loki /bitnami/grafana-loki/wal && chmod -R g+rwX /bitnami/grafana-loki && ln -s  /bitnami/grafana-loki/loki /loki && ln -s /bitnami/grafana-loki/data /data && ln -s /bitnami/grafana-loki/wal /wal

ENV APP_VERSION="2.6.0" \
    BITNAMI_APP_NAME="grafana-loki" \
    PATH="/opt/bitnami/grafana-loki/bin:$PATH"

EXPOSE 3100

USER 1001
ENTRYPOINT [ "loki" ]
CMD [ "-config.file=/bitnami/grafana-loki/conf/loki.yaml" ]
