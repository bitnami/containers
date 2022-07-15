FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/consul-exporter-0.8.0-152-linux-amd64-debian-11.tar.gz && \
    echo "6f8eca25d1703e3d6bb6330d02e0dbca469a8e5691efd1f14a9b070463a6dbb2  /tmp/bitnami/pkg/cache/consul-exporter-0.8.0-152-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/consul-exporter-0.8.0-152-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/consul-exporter-0.8.0-152-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -sf /opt/bitnami/consul-exporter/bin/consul_exporter /bin/consul_exporter

ENV APP_VERSION="0.8.0" \
    BITNAMI_APP_NAME="consul-exporter" \
    PATH="/opt/bitnami/consul-exporter/bin:$PATH"

EXPOSE 9107

WORKDIR /opt/bitnami/consul-exporter
USER 1001
ENTRYPOINT [ "consul_exporter" ]
