FROM bitnami/oraclelinux-runtimes:7-r291
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl gcc gcc-c++ git glibc keyutils-libs krb5-libs libcom_err libselinux libtool make ncurses-libs nss-softokn-freebl openssl-libs patch pcre pkgconfig readline unzip wget zlib
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/ruby-2.6.2-0-linux-x86_64-ol-7.tar.gz && \
    echo "705490e8a24d1bed3a190b83a0ef6d7aca8a5cf14f49f5b6c1fcf6a40f272983  /tmp/bitnami/pkg/cache/ruby-2.6.2-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/ruby-2.6.2-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/ruby-2.6.2-0-linux-x86_64-ol-7.tar.gz

ENV BITNAMI_APP_NAME="ruby" \
    BITNAMI_IMAGE_VERSION="2.6.2-ol-7-r33" \
    PATH="/opt/bitnami/ruby/bin:$PATH"

EXPOSE 3000

WORKDIR /app
CMD [ "irb" ]
