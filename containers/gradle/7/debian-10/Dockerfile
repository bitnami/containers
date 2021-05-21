FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/app" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/java-11.0.11-0-linux-amd64-debian-10.tar.gz && \
    echo "8cf28afc1090b0fec1ad841012ead25b59d2d5f4212742c3d62e6007ef57850b  /tmp/bitnami/pkg/cache/java-11.0.11-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/java-11.0.11-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/java-11.0.11-0-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/gradle-7.0.2-0-linux-amd64-debian-10.tar.gz && \
    echo "6776f5d3aa632efdd23f5f0546d1aa82db59916cc1997877c971db6e6fc0a60a  /tmp/bitnami/pkg/cache/gradle-7.0.2-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/gradle-7.0.2-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/gradle-7.0.2-0-linux-amd64-debian-10.tar.gz
RUN mkdir /app && chmod g+rwX /app

ENV BITNAMI_APP_NAME="gradle" \
    BITNAMI_IMAGE_VERSION="7.0.2-debian-10-r1" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/gradle/bin:$PATH"

WORKDIR /app
ENTRYPOINT [ "gradle" ]
CMD [ "--help" ]
