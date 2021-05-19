FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/open-service-broker-azure-1.8.4-2-linux-amd64-debian-10.tar.gz && \
    echo "9c19c9c17c2f431e28009edd04611d79f8e691e627471be9b6fd625ef60a7c48  /tmp/bitnami/pkg/cache/open-service-broker-azure-1.8.4-2-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/open-service-broker-azure-1.8.4-2-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/open-service-broker-azure-1.8.4-2-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="open-service-broker-azure" \
    BITNAMI_IMAGE_VERSION="1.8.4-debian-10-r439" \
    PATH="/opt/bitnami/open-service-broker-azure/bin:$PATH"

EXPOSE 8080

WORKDIR /opt/bitnami/open-service-broker-azure
USER 1001
ENTRYPOINT [ "/opt/bitnami/open-service-broker-azure/bin/broker" ]
