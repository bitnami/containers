FROM bitnami/oraclelinux-runtimes:7-r422
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs ca-certificates curl gcc gcc-c++ git glibc keyutils-libs krb5-libs libcom_err libgcc libselinux libstdc++ libtool make ncurses-libs nss-softokn-freebl openssl-libs patch pcre pkgconfig readline sqlite unzip wget zlib
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/node-12.10.0-0-linux-x86_64-ol-7.tar.gz && \
    echo "94dbd71d47ec886a80bc40468278b2add8ac4e7acc6ef982be87c18b3de2bbda  /tmp/bitnami/pkg/cache/node-12.10.0-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/node-12.10.0-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/node-12.10.0-0-linux-x86_64-ol-7.tar.gz

ENV BITNAMI_APP_NAME="node" \
    BITNAMI_IMAGE_VERSION="12.10.0-ol-7-r1" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH"

EXPOSE 3000

WORKDIR /app
CMD [ "node" ]
