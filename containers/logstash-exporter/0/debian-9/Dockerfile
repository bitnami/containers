FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl procps unzip wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/logstash-exporter-0.1.2-0-linux-amd64-debian-9.tar.gz && \
    echo "6ec379f5f2a2f3a34cc55d19fb9b1bdac0a990dda8458819f76da6f065b5a508  /tmp/bitnami/pkg/cache/logstash-exporter-0.1.2-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/logstash-exporter-0.1.2-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/logstash-exporter-0.1.2-0-linux-amd64-debian-9.tar.gz
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

ENV BITNAMI_APP_NAME="logstash-exporter" \
    BITNAMI_IMAGE_VERSION="0.1.2-debian-9-r70" \
    PATH="/opt/bitnami/logstash-exporter/bin:$PATH"

EXPOSE 9198

WORKDIR /opt/bitnami/logstash-exporter
USER 1001
ENTRYPOINT [ "logstash_exporter" ]
