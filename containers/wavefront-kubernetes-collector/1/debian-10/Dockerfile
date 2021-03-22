FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/wavefront-1.3.0-0-linux-amd64-debian-10.tar.gz && \
    echo "98e2c65761d01cdeb420c2c606c65f58258c314ff360c996bc13a46143961ef1  /tmp/bitnami/pkg/cache/wavefront-1.3.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/wavefront-1.3.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/wavefront-1.3.0-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="wavefront-kubernetes-collector" \
    BITNAMI_IMAGE_VERSION="1.3.0-debian-10-r31" \
    PATH="/opt/bitnami/wavefront/bin:$PATH"

USER 1001
ENTRYPOINT [ "wavefront-collector" ]
CMD [ "--help" ]
