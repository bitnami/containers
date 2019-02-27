FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates libc6 wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/open-service-broker-azure-1.5.0-0-linux-amd64-debian-9.tar.gz && \
    echo "2878235b9d550761bcb322b861ed17ef5e51ca90e93e365fdc55a3782bab518a  /tmp/bitnami/pkg/cache/open-service-broker-azure-1.5.0-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/open-service-broker-azure-1.5.0-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/open-service-broker-azure-1.5.0-0-linux-amd64-debian-9.tar.gz

ENV BITNAMI_APP_NAME="open-service-broker-azure" \
    BITNAMI_IMAGE_VERSION="1.5.0-debian-9-r6" \
    PATH="/opt/bitnami/open-service-broker-azure/bin:$PATH"

EXPOSE 8080

WORKDIR /opt/bitnami/open-service-broker-azure
USER 1001
ENTRYPOINT [ "/opt/bitnami/open-service-broker-azure/bin/broker" ]
