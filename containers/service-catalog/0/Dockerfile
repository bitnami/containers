FROM bitnami/minideb:jessie as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/service-catalog-0.1.25-0-linux-x64-debian-8.tar.gz && \
    echo "f74f2c275984a7650b2ebacacabe70ed240dab1b5175dd5a536a5387f41482d9  /tmp/bitnami/pkg/cache/service-catalog-0.1.25-0-linux-x64-debian-8.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/service-catalog-0.1.25-0-linux-x64-debian-8.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/service-catalog-0.1.25-0-linux-x64-debian-8.tar.gz

##################

FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/service-catalog /opt/bitnami/service-catalog
ENV BITNAMI_APP_NAME="service-catalog" \
    BITNAMI_IMAGE_VERSION="0.1.25-debian-8-r1" \
    PATH="/opt/bitnami/service-catalog/bin:$PATH"

EXPOSE 8443 443

WORKDIR /opt/bitnami/service-catalog
USER 1001
ENTRYPOINT ["/opt/bitnami/service-catalog/bin/service-catalog"]
