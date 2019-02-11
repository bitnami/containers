FROM bitnami/oraclelinux-runtimes:7-r230
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages build-essential bzip2-libs ca-certificates curl git glibc keyutils-libs krb5-libs libcom_err libgcc libselinux libstdc++ ncurses-libs nss-softokn-freebl openssl-libs pcre pkg-config readline sqlite unzip wget zlib
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/node-11.9.0-0-linux-x86_64-ol-7.tar.gz && \
    echo "c63691f4529e124b53a476f4dacfb6d559b30ebbc9e52d55d713fba8a890850f  /tmp/bitnami/pkg/cache/node-11.9.0-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/node-11.9.0-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/node-11.9.0-0-linux-x86_64-ol-7.tar.gz

ENV BITNAMI_APP_NAME="node" \
    BITNAMI_IMAGE_VERSION="11.9.0-ol-7-r8" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH"

EXPOSE 3000

WORKDIR /app
CMD [ "node" ]
