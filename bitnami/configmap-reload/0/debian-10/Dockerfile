FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl procps sudo unzip wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/configmap-reload-0.3.0-0-linux-amd64-debian-10.tar.gz && \
    echo "545bc2559b08e28c4741ea8ea5fb8445d8be58a28f395beb00f6800706a54965  /tmp/bitnami/pkg/cache/configmap-reload-0.3.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/configmap-reload-0.3.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/configmap-reload-0.3.0-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN ln -sf /opt/bitnami/configmap-reload/bin/configmap-reload /bin/configmap-reload

ENV BITNAMI_APP_NAME="configmap-reload" \
    BITNAMI_IMAGE_VERSION="0.3.0-debian-10-r11" \
    PATH="/opt/bitnami/configmap-reload/bin:$PATH"

EXPOSE 8080

WORKDIR /opt/bitnami/configmap-reload
USER 1001
ENTRYPOINT [ "configmap-reload" ]
