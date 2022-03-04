FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/fluentd-exporter-0.2.0-30-linux-amd64-debian-10.tar.gz && \
    echo "0c09a287f0f9310d3778fee0aafe5bc0fb3b2c5a03f51e0e8e96a21d1d68b445  /tmp/bitnami/pkg/cache/fluentd-exporter-0.2.0-30-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/fluentd-exporter-0.2.0-30-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/fluentd-exporter-0.2.0-30-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="fluentd-exporter" \
    BITNAMI_IMAGE_VERSION="0.2.0-debian-10-r717" \
    PATH="/opt/bitnami/fluentd-exporter/bin:$PATH"

EXPOSE 9309

WORKDIR /opt/bitnami/fluentd-exporter
USER 1001
ENTRYPOINT [ "fluentd_exporter" ]
