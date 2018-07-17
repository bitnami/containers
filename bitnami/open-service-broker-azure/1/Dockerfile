FROM bitnami/minideb:jessie as buildenv

RUN install_packages ca-certificates libc6 wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/open-service-broker-azure-1.0.1-0-linux-x64-debian-8.tar.gz && \
    echo "9e8b881a6dcf9781803810d66c2048ef3655ea3c704c40a5b5168ac4cbf86dfd  /tmp/bitnami/pkg/cache/open-service-broker-azure-1.0.1-0-linux-x64-debian-8.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/open-service-broker-azure-1.0.1-0-linux-x64-debian-8.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/open-service-broker-azure-1.0.1-0-linux-x64-debian-8.tar.gz

##################

FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/open-service-broker-azure /opt/bitnami/open-service-broker-azure
ENV BITNAMI_APP_NAME="open-service-broker-azure" \
    BITNAMI_IMAGE_VERSION="1.0.1-debian-8-r0" \
    PATH="/opt/bitnami/open-service-broker-azure/bin:$PATH"

RUN install_packages ca-certificates

EXPOSE 8080

WORKDIR /opt/bitnami/open-service-broker-azure
USER 1001
ENTRYPOINT ["/opt/bitnami/open-service-broker-azure/bin/broker"]
