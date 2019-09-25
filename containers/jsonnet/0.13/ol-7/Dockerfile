FROM bitnami/oraclelinux-extras:7-r477
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates glibc libgcc libstdc++ wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/jsonnet-0.13.0-2-linux-x86_64-ol-7.tar.gz && \
    echo "ff90c56f89ebc358973109bd1242f7a2a18d76af22261756898cc4d9fa41265d  /tmp/bitnami/pkg/cache/jsonnet-0.13.0-2-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/jsonnet-0.13.0-2-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/jsonnet-0.13.0-2-linux-x86_64-ol-7.tar.gz

RUN chmod +x /opt/bitnami/jsonnet/bin/jsonnet
ENV BITNAMI_APP_NAME="jsonnet" \
    BITNAMI_IMAGE_VERSION="0.13.0-ol-7-r106" \
    PATH="/opt/bitnami/jsonnet/bin:$PATH"

USER 1001
ENTRYPOINT [ "jsonnet" ]
CMD [ "--help" ]
