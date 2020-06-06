FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl libc6 procps sudo unzip wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/contour-1.5.0-0-linux-amd64-debian-10.tar.gz && \
    echo "d35dcb4cc5774d3fc179d9cfa3c79263dcacf6e5de7a9767be66dddcc5434095  /tmp/bitnami/pkg/cache/contour-1.5.0-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/contour-1.5.0-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/contour-1.5.0-0-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

ENV BITNAMI_APP_NAME="contour" \
    BITNAMI_IMAGE_VERSION="1.5.0-debian-10-r1" \
    PATH="/opt/bitnami/contour/bin:$PATH"

USER 1001
ENTRYPOINT [ "contour" ]
