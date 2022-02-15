FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/contour-1.20.0-1-linux-amd64-debian-10.tar.gz && \
    echo "8f6224060b2c946a0cade8c9e9e97f4b9e24a43e496cde1600f46ea3fd51222c  /tmp/bitnami/pkg/cache/contour-1.20.0-1-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/contour-1.20.0-1-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/contour-1.20.0-1-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -s /opt/bitnami/contour/bin/contour /bin/contour

ENV BITNAMI_APP_NAME="contour" \
    BITNAMI_IMAGE_VERSION="1.20.0-debian-10-r1" \
    PATH="/opt/bitnami/contour/bin:$PATH"

USER 1001
ENTRYPOINT [ "contour" ]
