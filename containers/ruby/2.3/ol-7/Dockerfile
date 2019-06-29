FROM bitnami/oraclelinux-runtimes:7-r353
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl gcc gcc-c++ git glibc keyutils-libs krb5-libs libcom_err libselinux libtool make ncurses-libs nss-softokn-freebl openssl-libs patch pcre pkgconfig readline unzip wget zlib
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/ruby-2.3.8-21-linux-x86_64-ol-7.tar.gz && \
    echo "bde153ab8ad282e02eee020e65d2d53c84dbf6b5a4212011b29a2b1ef9d3a527  /tmp/bitnami/pkg/cache/ruby-2.3.8-21-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/ruby-2.3.8-21-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/ruby-2.3.8-21-linux-x86_64-ol-7.tar.gz

ENV BITNAMI_APP_NAME="ruby" \
    BITNAMI_IMAGE_VERSION="2.3.8-ol-7-r226" \
    PATH="/opt/bitnami/ruby/bin:$PATH"

EXPOSE 3000

WORKDIR /app
CMD [ "irb" ]
