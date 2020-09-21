FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/envoy-1.15.0-0-linux-amd64-debian-10.tar.gz && \
    echo "8288df712ff6b84a1275ac3a488d26e000abb30f830f3f6a4993c29f7c038fbc  /tmp/bitnami/pkg/cache/envoy-1.15.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/envoy-1.15.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/envoy-1.15.0-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="envoy" \
    BITNAMI_IMAGE_VERSION="1.15.0-debian-10-r51" \
    PATH="/opt/bitnami/envoy/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/envoy/bin/envoy" ]
CMD [ "-c", "/opt/bitnami/envoy/conf/envoy.yaml" ]
