FROM bitnami/minideb:stretch as buildenv

RUN install_packages ca-certificates libc6 wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/open-service-broker-azure-1.0.1-0-linux-amd64-debian-9.tar.gz && \
    echo "5a99eb5aeb039eed9f088514ea5c25b0f96c61b675067b9a1e13736ccac26e52  /tmp/bitnami/pkg/cache/open-service-broker-azure-1.0.1-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/open-service-broker-azure-1.0.1-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/open-service-broker-azure-1.0.1-0-linux-amd64-debian-9.tar.gz

##################

FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/open-service-broker-azure /opt/bitnami/open-service-broker-azure
ENV BITNAMI_APP_NAME="open-service-broker-azure" \
    BITNAMI_IMAGE_VERSION="1.0.1-debian-9-r13" \
    PATH="/opt/bitnami/open-service-broker-azure/bin:$PATH"

RUN install_packages ca-certificates

EXPOSE 8080

WORKDIR /opt/bitnami/open-service-broker-azure
USER 1001
ENTRYPOINT ["/opt/bitnami/open-service-broker-azure/bin/broker"]
