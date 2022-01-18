FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/app" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/java-11.0.13-1-linux-amd64-debian-10.tar.gz && \
    echo "cf2e298428d67fb30c376ee6638c055afe54cc1f282bab314abc53a34c37be44  /tmp/bitnami/pkg/cache/java-11.0.13-1-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/java-11.0.13-1-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/java-11.0.13-1-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/gradle-7.3.3-1-linux-amd64-debian-10.tar.gz && \
    echo "98b90f1e91511f763304db0da794139ce3337a9ef900af40f43bc6e42a6fe2dd  /tmp/bitnami/pkg/cache/gradle-7.3.3-1-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/gradle-7.3.3-1-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/gradle-7.3.3-1-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN mkdir /app && chmod g+rwX /app

ENV BITNAMI_APP_NAME="gradle" \
    BITNAMI_IMAGE_VERSION="7.3.3-debian-10-r25" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/gradle/bin:$PATH"

WORKDIR /app
ENTRYPOINT [ "gradle" ]
CMD [ "--help" ]
