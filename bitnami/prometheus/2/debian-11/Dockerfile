FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="2.38.0-debian-11-r5" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/prometheus" \
      org.opencontainers.image.title="prometheus" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="2.38.0"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f prometheus-2.38.0-1-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/prometheus-2.38.0-1-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "2513dd02c1f271bfc49746068a5f2f2a3c61ddf84394830519e4cf35b96dc954  prometheus-2.38.0-1-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf prometheus-2.38.0-1-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf prometheus-2.38.0-1-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -sf /opt/bitnami/prometheus/conf /etc/prometheus
RUN ln -sf /opt/bitnami/prometheus/data /prometheus
RUN chown -R 1001:1001 /opt/bitnami/prometheus

RUN mkdir -p /opt/bitnami/prometheus/data/ && chmod g+rwX /opt/bitnami/prometheus/data/
ENV APP_VERSION="2.38.0" \
    BITNAMI_APP_NAME="prometheus" \
    PATH="/opt/bitnami/prometheus/bin:$PATH"

EXPOSE 9090

WORKDIR /opt/bitnami/prometheus
USER 1001
ENTRYPOINT [ "/opt/bitnami/prometheus/bin/prometheus" ]
CMD [ "--config.file=/opt/bitnami/prometheus/conf/prometheus.yml", "--storage.tsdb.path=/opt/bitnami/prometheus/data", "--web.console.libraries=/opt/bitnami/prometheus/conf/console_libraries", "--web.console.templates=/opt/bitnami/prometheus/conf/consoles" ]
