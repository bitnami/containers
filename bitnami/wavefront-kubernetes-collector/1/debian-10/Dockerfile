FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/wavefront-1.2.6-1-linux-amd64-debian-10.tar.gz && \
    echo "8ef2228d1d6e4f5b527bc17f693164f968c31a97a2c96e39299b9d038d1ad88a  /tmp/bitnami/pkg/cache/wavefront-1.2.6-1-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/wavefront-1.2.6-1-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/wavefront-1.2.6-1-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="wavefront-kubernetes-collector" \
    BITNAMI_IMAGE_VERSION="1.2.6-debian-10-r41" \
    PATH="/opt/bitnami/wavefront/bin:$PATH"

USER 1001
ENTRYPOINT [ "wavefront-collector" ]
CMD [ "--help" ]
