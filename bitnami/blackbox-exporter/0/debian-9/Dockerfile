FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/blackbox-exporter-0.15.1-1-linux-amd64-debian-9.tar.gz && \
    echo "811ec440c36f5d3941ed0518d36856f25c4d40e794cf1025e4e04eb5fe8b808a  /tmp/bitnami/pkg/cache/blackbox-exporter-0.15.1-1-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/blackbox-exporter-0.15.1-1-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/blackbox-exporter-0.15.1-1-linux-amd64-debian-9.tar.gz

ENV BITNAMI_APP_NAME="blackbox-exporter" \
    BITNAMI_IMAGE_VERSION="0.15.1-debian-9-r24" \
    PATH="/opt/bitnami/blackbox-exporter/bin:$PATH"

EXPOSE 9115

WORKDIR /opt/bitnami/blackbox-exporter
USER 1001
ENTRYPOINT [ "/opt/bitnami/blackbox-exporter/bin/blackbox_exporter" ]
