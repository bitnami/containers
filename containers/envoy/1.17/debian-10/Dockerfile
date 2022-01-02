FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/envoy-1.17.4-0-linux-amd64-debian-10.tar.gz && \
    echo "c4375d332d609eb2593c28807682daa762b1dd5e00d300ebc7f0738d9a5d2d3a  /tmp/bitnami/pkg/cache/envoy-1.17.4-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/envoy-1.17.4-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/envoy-1.17.4-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="envoy" \
    BITNAMI_IMAGE_VERSION="1.17.4-debian-10-r127" \
    PATH="/opt/bitnami/envoy/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/envoy/bin/envoy" ]
CMD [ "-c", "/opt/bitnami/envoy/conf/envoy.yaml" ]
