FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/wavefront-adapter-for-istio-0.1.5-1-linux-amd64-debian-10.tar.gz && \
    echo "d898db47a97f48089903856c32f5c294d90661bc771dece94e9f9804af6447eb  /tmp/bitnami/pkg/cache/wavefront-adapter-for-istio-0.1.5-1-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/wavefront-adapter-for-istio-0.1.5-1-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/wavefront-adapter-for-istio-0.1.5-1-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="wavefront-adapter-for-istio" \
    BITNAMI_IMAGE_VERSION="0.1.5-debian-10-r275" \
    PATH="/opt/bitnami/wavefront-adapter-for-istio/bin:$PATH"

EXPOSE 37671

USER 1001
ENTRYPOINT [ "wavefront" ]
