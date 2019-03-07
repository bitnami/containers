FROM registry.rhc4tp.openshift.com/bitnami/rhel-extras-base-7:latest
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs ca-certificates cyrus-sasl-lib freetype glibc gmp keyutils-libs krb5-libs libcom_err libcurl libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libpng libselinux libssh2 libstdc++ libxml2 libxslt ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre postgresql-libs readline wget xz-libs zlib
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/php-7.3.2-1-linux-x86_64-rhel-7.tar.gz && \
    echo "b947b98dbe296f96b81a9583633584fb3dfe050b8d77d12752f5281f9716d3a4  /tmp/bitnami/pkg/cache/php-7.3.2-1-linux-x86_64-rhel-7.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/php-7.3.2-1-linux-x86_64-rhel-7.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/php-7.3.2-1-linux-x86_64-rhel-7.tar.gz
RUN mkdir -p /bitnami && ln -sf /bitnami/php /bitnami/php-fpm
RUN mkdir /opt/bitnami/php/logs && touch /opt/bitnami/php/logs/php-fpm.log
RUN chown -R 1001:root /opt/bitnami/php/logs

ENV BITNAMI_APP_NAME="php-fpm" \
    BITNAMI_IMAGE_VERSION="7.3.2-rhel-7-r27" \
    BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/php/sbin:$PATH"

EXPOSE 9000

WORKDIR /app
USER 1001
CMD [ "php-fpm", "-F", "--pid", "/opt/bitnami/php/tmp/php-fpm.pid", "-y", "/opt/bitnami/php/etc/php-fpm.conf" ]
