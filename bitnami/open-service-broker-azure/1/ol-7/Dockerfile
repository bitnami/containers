FROM bitnami/oraclelinux-extras:7-r63 as buildenv

RUN install_packages ca-certificates glibc wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/open-service-broker-azure-1.1.0-0-linux-x86_64-ol-7.tar.gz && \
    echo "5e7da11356ed5d3fb310f7a07949c686244b00616313cbc9f43853f209fd3101  /tmp/bitnami/pkg/cache/open-service-broker-azure-1.1.0-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/open-service-broker-azure-1.1.0-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/open-service-broker-azure-1.1.0-0-linux-x86_64-ol-7.tar.gz

##################

FROM bitnami/oraclelinux-extras:7-r63
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/open-service-broker-azure /opt/bitnami/open-service-broker-azure
ENV BITNAMI_APP_NAME="open-service-broker-azure" \
    BITNAMI_IMAGE_VERSION="1.1.0-ol-7-r2" \
    PATH="/opt/bitnami/open-service-broker-azure/bin:$PATH"

RUN install_packages ca-certificates

EXPOSE 8080

WORKDIR /opt/bitnami/open-service-broker-azure
USER 1001
ENTRYPOINT ["/opt/bitnami/open-service-broker-azure/bin/broker"]
