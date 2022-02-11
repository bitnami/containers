FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/consul-exporter-0.8.0-1-linux-amd64-debian-10.tar.gz && \
    echo "5140aab6c8c845256912e3fe843f2ae1b809056cc54c97e2164c93427d83d145  /tmp/bitnami/pkg/cache/consul-exporter-0.8.0-1-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/consul-exporter-0.8.0-1-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/consul-exporter-0.8.0-1-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -sf /opt/bitnami/consul-exporter/bin/consul_exporter /bin/consul_exporter

ENV BITNAMI_APP_NAME="consul-exporter" \
    BITNAMI_IMAGE_VERSION="0.8.0-debian-10-r0" \
    PATH="/opt/bitnami/consul-exporter/bin:$PATH"

EXPOSE 9107

WORKDIR /opt/bitnami/consul-exporter
USER 1001
ENTRYPOINT [ "consul_exporter" ]
