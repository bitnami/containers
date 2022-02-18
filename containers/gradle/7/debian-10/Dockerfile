FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/app" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/java-11.0.14-6-linux-amd64-debian-10.tar.gz && \
    echo "8e9d15dc54b3cf57e7f3b92efbb1e01ed07f002889034ec7703b62efb8265243  /tmp/bitnami/pkg/cache/java-11.0.14-6-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/java-11.0.14-6-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/java-11.0.14-6-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/gradle-7.4.0-3-linux-amd64-debian-10.tar.gz && \
    echo "ef912f602a83b8cc1f8887fc7dcf5ecc356546c0ac448f62e0ac7e876e57b84b  /tmp/bitnami/pkg/cache/gradle-7.4.0-3-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/gradle-7.4.0-3-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/gradle-7.4.0-3-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN mkdir /app && chmod g+rwX /app

ENV BITNAMI_APP_NAME="gradle" \
    BITNAMI_IMAGE_VERSION="7.4.0-debian-10-r9" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/gradle/bin:$PATH"

WORKDIR /app
ENTRYPOINT [ "gradle" ]
CMD [ "--help" ]
