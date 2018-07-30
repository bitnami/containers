FROM bitnami/oraclelinux-extras:7-r52 as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/service-catalog-0.1.27-0-linux-x86_64-ol-7.tar.gz && \
    echo "5339d0be84b135da62ff89687cd5dbf5e9ea4848c0692991eae8334f863fe6a0  /tmp/bitnami/pkg/cache/service-catalog-0.1.27-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/service-catalog-0.1.27-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/service-catalog-0.1.27-0-linux-x86_64-ol-7.tar.gz

##################

FROM bitnami/oraclelinux-extras:7-r52
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/service-catalog /opt/bitnami/service-catalog
ENV BITNAMI_APP_NAME="service-catalog" \
    BITNAMI_IMAGE_VERSION="0.1.27-ol-7-r3" \
    PATH="/opt/bitnami/service-catalog/bin:$PATH"

EXPOSE 8443 443

WORKDIR /opt/bitnami/service-catalog
USER 1001
ENTRYPOINT ["/opt/bitnami/service-catalog/bin/service-catalog"]
