FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip hostname libaio-devel procps-ng sudo tar wget which
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/configmap-reload-0.3.0-0-linux-x86_64-ol-7.tar.gz && \
    echo "717785c3f49a33aa4f5d6f318aae5d3e5b1ec5527b2f598b79a91a0e2304c1de  /tmp/bitnami/pkg/cache/configmap-reload-0.3.0-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/configmap-reload-0.3.0-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/configmap-reload-0.3.0-0-linux-x86_64-ol-7.tar.gz
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN ln -sf /opt/bitnami/configmap-reload/bin/configmap-reload /bin/configmap-reload

ENV BITNAMI_APP_NAME="configmap-reload" \
    BITNAMI_IMAGE_VERSION="0.3.0-ol-7-r107" \
    PATH="/opt/bitnami/configmap-reload/bin:$PATH"

EXPOSE 8080

WORKDIR /opt/bitnami/configmap-reload
USER 1001
ENTRYPOINT [ "configmap-reload" ]
