FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl procps unzip wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/pushgateway-1.0.0-0-linux-amd64-debian-9.tar.gz && \
    echo "f1561253077dd8ae32f6f447c13536c6f5cb78c922b7498e9ae3ec227e2979c5  /tmp/bitnami/pkg/cache/pushgateway-1.0.0-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/pushgateway-1.0.0-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/pushgateway-1.0.0-0-linux-amd64-debian-9.tar.gz

ENV BITNAMI_APP_NAME="pushgateway" \
    BITNAMI_IMAGE_VERSION="1.0.0-debian-9-r50" \
    PATH="/opt/bitnami/pushgateway/bin:$PATH"

EXPOSE 9091

WORKDIR /opt/bitnami/pushgateway
USER 1001
ENTRYPOINT [ "/opt/bitnami/pushgateway/bin/pushgateway" ]
