FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="0.20220314.0-debian-11-r32" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/airflow-exporter" \
      org.opencontainers.image.title="airflow-exporter" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="0.20220314.0"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f airflow-exporter-0.20220314.0-153-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/airflow-exporter-0.20220314.0-153-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "55c38fb6c63a3b6df3eb928f2907841fb8044c0c994f13366fd115f4a104fda7  airflow-exporter-0.20220314.0-153-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf airflow-exporter-0.20220314.0-153-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --wildcards '*/files' && \
    rm -rf airflow-exporter-0.20220314.0-153-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV APP_VERSION="0.20220314.0" \
    BITNAMI_APP_NAME="airflow-exporter" \
    PATH="/opt/bitnami/airflow-exporter/bin:$PATH"

EXPOSE 9112

WORKDIR /opt/bitnami/airflow-exporter
USER 1001
ENTRYPOINT [ "airflow-prometheus-exporter" ]
