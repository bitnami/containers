FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/prometheus-2.19.1-0-linux-amd64-debian-10.tar.gz && \
    echo "2a1771b218fae656746d517604265a9ae4d9cbab39a1bd0c228e5ce7f7f4685f  /tmp/bitnami/pkg/cache/prometheus-2.19.1-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/prometheus-2.19.1-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/prometheus-2.19.1-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN ln -sf /opt/bitnami/prometheus/conf /etc/prometheus
RUN ln -sf /opt/bitnami/prometheus/data /prometheus

RUN mkdir -p /opt/bitnami/prometheus/data/ && chmod g+rwX /opt/bitnami/prometheus/data/
ENV BITNAMI_APP_NAME="prometheus" \
    BITNAMI_IMAGE_VERSION="2.19.1-debian-10-r4" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux" \
    PATH="/opt/bitnami/prometheus/bin:$PATH"

EXPOSE 9090

WORKDIR /opt/bitnami/prometheus
USER 1001
ENTRYPOINT [ "/opt/bitnami/prometheus/bin/prometheus" ]
CMD [ "--config.file=/opt/bitnami/prometheus/conf/prometheus.yml", "--storage.tsdb.path=/opt/bitnami/prometheus/data", "--web.console.libraries=/opt/bitnami/prometheus/conf/console_libraries", "--web.console.templates=/opt/bitnami/prometheus/conf/consoles" ]
