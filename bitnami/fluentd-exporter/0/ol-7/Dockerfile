FROM bitnami/oraclelinux-extras:7-r263
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/fluentd-exporter-0.2.0-20-linux-x86_64-ol-7.tar.gz && \
    echo "f5e14b478df1639746b5bfb549dd9075219b69259ea385f58a504e8a08a2076f  /tmp/bitnami/pkg/cache/fluentd-exporter-0.2.0-20-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/fluentd-exporter-0.2.0-20-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/fluentd-exporter-0.2.0-20-linux-x86_64-ol-7.tar.gz

ENV BITNAMI_APP_NAME="fluentd-exporter" \
    BITNAMI_IMAGE_VERSION="0.2.0-ol-7-r206" \
    PATH="/opt/bitnami/fluentd-exporter/bin:$PATH"

EXPOSE 9309

WORKDIR /opt/bitnami/fluentd-exporter
USER 1001
ENTRYPOINT [ "fluentd_exporter" ]
