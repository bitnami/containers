FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/pushgateway-0.7.0-20-linux-amd64-debian-9.tar.gz && \
    echo "378f0704fa998ccbf7d440b3c8b925ca3a6fafb09f4e46aa630dfbecf9bdfad8  /tmp/bitnami/pkg/cache/pushgateway-0.7.0-20-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/pushgateway-0.7.0-20-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/pushgateway-0.7.0-20-linux-amd64-debian-9.tar.gz

ENV BITNAMI_APP_NAME="pushgateway" \
    BITNAMI_IMAGE_VERSION="0.7.0-debian-9-r63" \
    PATH="/opt/bitnami/pushgateway/bin:$PATH"

EXPOSE 9091

WORKDIR /opt/bitnami/pushgateway
USER 1001
ENTRYPOINT [ "/opt/bitnami/pushgateway/bin/pushgateway" ]
