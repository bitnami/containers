FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl procps unzip wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/consul-exporter-0.6.0-0-linux-amd64-debian-9.tar.gz && \
    echo "4c6e5460bf9d0458077574942c823e16680cbecfed02ff026cbe4a9f90ecbb3a  /tmp/bitnami/pkg/cache/consul-exporter-0.6.0-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/consul-exporter-0.6.0-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/consul-exporter-0.6.0-0-linux-amd64-debian-9.tar.gz
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN ln -sf /opt/bitnami/consul-exporter/bin/consul_exporter /bin/consul_exporter

ENV BITNAMI_APP_NAME="consul-exporter" \
    BITNAMI_IMAGE_VERSION="0.6.0-debian-9-r11" \
    PATH="/opt/bitnami/consul-exporter/bin:$PATH"

EXPOSE 9107

WORKDIR /opt/bitnami/consul-exporter
USER 1001
ENTRYPOINT [ "consul_exporter" ]
