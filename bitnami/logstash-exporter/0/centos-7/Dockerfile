FROM bitnami/centos-extras-base:7-r256
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/logstash-exporter-0.1.2-0-linux-x86_64-centos-7.tar.gz && \
    echo "7e49dbfc226d6fc4d468dc5e24faa3a5482269661939c7d5d56f38974b31fbf9  /tmp/bitnami/pkg/cache/logstash-exporter-0.1.2-0-linux-x86_64-centos-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/logstash-exporter-0.1.2-0-linux-x86_64-centos-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/logstash-exporter-0.1.2-0-linux-x86_64-centos-7.tar.gz

ENV BITNAMI_APP_NAME="logstash-exporter" \
    BITNAMI_IMAGE_VERSION="0.1.2-centos-7-r82" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="centos-7" \
    OS_NAME="linux" \
    PATH="/opt/bitnami/logstash-exporter/bin:$PATH"

EXPOSE 9198

WORKDIR /opt/bitnami/logstash-exporter
USER 1001
ENTRYPOINT [ "logstash_exporter" ]
