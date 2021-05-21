FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl ghostscript gzip imagemagick libbz2-1.0 libc6 libffi6 libgcc1 liblzma5 libncursesw6 libreadline7 libsqlite3-0 libssl1.1 libstdc++6 libtinfo6 procps tar wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/node-10.24.1-1-linux-amd64-debian-10.tar.gz && \
    echo "78c457d92efd6a3dbd92a91723670c4166d6a520fd95ec98a5431eb6642d2420  /tmp/bitnami/pkg/cache/node-10.24.1-1-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/node-10.24.1-1-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/node-10.24.1-1-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/configurable-http-proxy-4.3.2-0-linux-amd64-debian-10.tar.gz && \
    echo "3661612ef6322ec9215eba4cd5c89924fed3f3536a0ad112b90faeb9884538ba  /tmp/bitnami/pkg/cache/configurable-http-proxy-4.3.2-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/configurable-http-proxy-4.3.2-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/configurable-http-proxy-4.3.2-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami

ENV BITNAMI_APP_NAME="configurable-http-proxy" \
    BITNAMI_IMAGE_VERSION="4.3.2-debian-10-r35" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/python/bin:/opt/bitnami/configurable-http-proxy/bin:$PATH"

EXPOSE 3000

USER 1001
ENTRYPOINT [ "configurable-http-proxy" ]
