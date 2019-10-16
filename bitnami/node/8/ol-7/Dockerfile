FROM bitnami/oraclelinux-runtimes:7-r469
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs ca-certificates curl gcc gcc-c++ git glibc keyutils-libs krb5-libs libcom_err libgcc libselinux libstdc++ libtool make ncurses-libs nss-softokn-freebl openssl-libs patch pcre pkgconfig readline sqlite unzip wget zlib
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/node-8.16.2-0-linux-x86_64-ol-7.tar.gz && \
    echo "05f97e6484456e724c829ecb61c3c5a062ae1d24cf066b1668452b7660c428c3  /tmp/bitnami/pkg/cache/node-8.16.2-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/node-8.16.2-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/node-8.16.2-0-linux-x86_64-ol-7.tar.gz

ENV BITNAMI_APP_NAME="node" \
    BITNAMI_IMAGE_VERSION="8.16.2-ol-7-r7" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH"

EXPOSE 3000

WORKDIR /app
CMD [ "node" ]
