FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/cainjector-1.7.1-1-linux-amd64-debian-10.tar.gz && \
    echo "58dd6f2974f26eb5820353c0b83d406eeffd22c7992e8d7442eddb80053bfa7f  /tmp/bitnami/pkg/cache/cainjector-1.7.1-1-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/cainjector-1.7.1-1-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/cainjector-1.7.1-1-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="cainjector" \
    BITNAMI_IMAGE_VERSION="1.7.1-debian-10-r9" \
    PATH="/opt/bitnami/cainjector/bin:$PATH"

WORKDIR /opt/bitnami/cainjector
USER 1001
ENTRYPOINT [ "/opt/bitnami/cainjector/bin/cainjector" ]
