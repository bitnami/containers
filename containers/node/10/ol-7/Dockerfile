FROM bitnami/oraclelinux-runtimes:7-r88
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages build-essential bzip2-libs ca-certificates curl git glibc keyutils-libs krb5-libs libcom_err libgcc libselinux libstdc++ ncurses-libs nss-softokn-freebl openssl-libs pcre pkg-config readline sqlite unzip wget zlib
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/node-10.11.0-0-linux-x86_64-ol-7.tar.gz && \
    echo "fdc2778b6e46445e75d27659606203f2a48a795ba832aec962a0412d3ff1dcc6  /tmp/bitnami/pkg/cache/node-10.11.0-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/node-10.11.0-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/node-10.11.0-0-linux-x86_64-ol-7.tar.gz

ENV BITNAMI_APP_NAME="node" \
    BITNAMI_IMAGE_VERSION="10.11.0-ol-7-r5" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH"

EXPOSE 3000

WORKDIR /app
CMD [ "node" ]
