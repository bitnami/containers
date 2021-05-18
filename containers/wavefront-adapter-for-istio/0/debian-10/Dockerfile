FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/wavefront-adapter-for-istio-0.1.5-0-linux-amd64-debian-10.tar.gz && \
    echo "1879231a99fa832c687d37b203992a66d08dc04101077ba1be3ee9019f8d00cd  /tmp/bitnami/pkg/cache/wavefront-adapter-for-istio-0.1.5-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/wavefront-adapter-for-istio-0.1.5-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/wavefront-adapter-for-istio-0.1.5-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="wavefront-adapter-for-istio" \
    BITNAMI_IMAGE_VERSION="0.1.5-debian-10-r47" \
    PATH="/opt/bitnami/wavefront-adapter-for-istio/bin:$PATH"

EXPOSE 37671

USER 1001
ENTRYPOINT [ "wavefront" ]
