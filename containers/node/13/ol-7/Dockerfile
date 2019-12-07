FROM bitnami/oraclelinux-runtimes:7-r527
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs ca-certificates curl gcc gcc-c++ git glibc keyutils-libs krb5-libs libcom_err libgcc libselinux libstdc++ libtool make ncurses-libs nss-softokn-freebl openssl-libs patch pcre pkgconfig readline sqlite unzip wget zlib
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/node-13.3.0-0-linux-x86_64-ol-7.tar.gz && \
    echo "df397fd4c1a8c2267ac1ab4d3d3b33b16ee4048bed79c045950f1e5f1af21afb  /tmp/bitnami/pkg/cache/node-13.3.0-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/node-13.3.0-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/node-13.3.0-0-linux-x86_64-ol-7.tar.gz

ENV BITNAMI_APP_NAME="node" \
    BITNAMI_IMAGE_VERSION="13.3.0-ol-7-r3" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH"

EXPOSE 3000

WORKDIR /app
CMD [ "node" ]
