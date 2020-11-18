FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/wavefront-1.2.5-0-linux-amd64-debian-10.tar.gz && \
    echo "747dd8072f58068da3cc696f28426f5b6060f82f31805d8a9d5153f835a7c284  /tmp/bitnami/pkg/cache/wavefront-1.2.5-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/wavefront-1.2.5-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/wavefront-1.2.5-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="wavefront-kubernetes-collector" \
    BITNAMI_IMAGE_VERSION="1.2.5-debian-10-r0" \
    PATH="/opt/bitnami/wavefront/bin:$PATH"

USER 1001
ENTRYPOINT [ "wavefront-collector" ]
CMD [ "--help" ]
