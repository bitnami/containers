FROM bitnami/oraclelinux-runtimes:7-r113
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages build-essential ca-certificates curl git glibc keyutils-libs krb5-libs libcom_err libselinux ncurses-libs nss-softokn-freebl openssl-libs pcre pkg-config readline unzip wget zlib
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/ruby-2.5.1-1-linux-x86_64-ol-7.tar.gz && \
    echo "f9eb3a0b6b7ef5652f128dbdeb3bc199cbb9e4717ab2b6b44b66fabd050dfd65  /tmp/bitnami/pkg/cache/ruby-2.5.1-1-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/ruby-2.5.1-1-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/ruby-2.5.1-1-linux-x86_64-ol-7.tar.gz
RUN /opt/bitnami/ruby/bin/gem install bundler

ENV BITNAMI_APP_NAME="ruby" \
    BITNAMI_IMAGE_VERSION="2.5.1-ol-7-r105" \
    PATH="/opt/bitnami/ruby/bin:$PATH"

EXPOSE 3000

WORKDIR /app
CMD [ "irb" ]
