FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip hostname libaio-devel procps-ng sudo tar wget which
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/logstash-exporter-0.1.2-0-linux-x86_64-ol-7.tar.gz && \
    echo "cf2a0eaf40ac8cce3dc3b97def29c685adfa627505f905e3f11accb8b5796a28  /tmp/bitnami/pkg/cache/logstash-exporter-0.1.2-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/logstash-exporter-0.1.2-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/logstash-exporter-0.1.2-0-linux-x86_64-ol-7.tar.gz
RUN yum upgrade -y && \
    rm -r /var/cache/yum

ENV BITNAMI_APP_NAME="logstash-exporter" \
    BITNAMI_IMAGE_VERSION="0.1.2-ol-7-r109" \
    PATH="/opt/bitnami/logstash-exporter/bin:$PATH"

EXPOSE 9198

WORKDIR /opt/bitnami/logstash-exporter
USER 1001
ENTRYPOINT [ "logstash_exporter" ]
