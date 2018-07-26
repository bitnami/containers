FROM bitnami/oraclelinux-extras:7-r48 as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/service-catalog-0.1.26-0-linux-x86_64-ol-7.tar.gz && \
    echo "c7dc793b0a2cb1d9ab603b2aab51c5ad32dc3492754ccd3ff26fb88c745d2abe  /tmp/bitnami/pkg/cache/service-catalog-0.1.26-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/service-catalog-0.1.26-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/service-catalog-0.1.26-0-linux-x86_64-ol-7.tar.gz

##################

FROM bitnami/oraclelinux-extras:7-r48
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/service-catalog /opt/bitnami/service-catalog
ENV BITNAMI_APP_NAME="service-catalog" \
    BITNAMI_IMAGE_VERSION="0.1.26-ol-7-r5" \
    PATH="/opt/bitnami/service-catalog/bin:$PATH"

EXPOSE 8443 443

WORKDIR /opt/bitnami/service-catalog
USER 1001
ENTRYPOINT ["/opt/bitnami/service-catalog/bin/service-catalog"]
