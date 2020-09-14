FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/configmap-reload-0.4.0-0-linux-amd64-debian-10.tar.gz && \
    echo "2918cf651d3daddd9a112480ae769fa4ba9d8facbde51f0e559a7595f8b51514  /tmp/bitnami/pkg/cache/configmap-reload-0.4.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/configmap-reload-0.4.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/configmap-reload-0.4.0-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -sf /opt/bitnami/configmap-reload/bin/configmap-reload /bin/configmap-reload

ENV BITNAMI_APP_NAME="configmap-reload" \
    BITNAMI_IMAGE_VERSION="0.4.0-debian-10-r46" \
    PATH="/opt/bitnami/configmap-reload/bin:$PATH"

EXPOSE 8080

WORKDIR /opt/bitnami/configmap-reload
USER 1001
ENTRYPOINT [ "configmap-reload" ]
