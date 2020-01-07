FROM bitnami/oraclelinux-runtimes:7-r557
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs ca-certificates cyrus-sasl-lib freetds-libs freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline wget xz-libs zlib
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/php-7.2.26-0-linux-x86_64-ol-7.tar.gz && \
    echo "8a6d5adeb4cbb51b17809ccd57c005ff2148a4c4086d99ace2bd938646874d07  /tmp/bitnami/pkg/cache/php-7.2.26-0-linux-x86_64-ol-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/php-7.2.26-0-linux-x86_64-ol-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/php-7.2.26-0-linux-x86_64-ol-7.tar.gz

ENV BITNAMI_APP_NAME="php-fpm" \
    BITNAMI_IMAGE_VERSION="7.2.26-ol-7-r20" \
    PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:$PATH"

EXPOSE 9000

WORKDIR /app
CMD [ "php-fpm", "-F", "--pid", "/opt/bitnami/php/tmp/php-fpm.pid", "-y", "/opt/bitnami/php/etc/php-fpm.conf" ]
