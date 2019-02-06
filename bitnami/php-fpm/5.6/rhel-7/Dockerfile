FROM registry.rhc4tp.openshift.com/bitnami/rhel-extras-7:latest
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib freetype glibc gmp keyutils-libs krb5-libs libcom_err libcurl libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libpng libselinux libssh2 libstdc++ libxml2 libxslt ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre postgresql-libs readline xz-libs zlib
RUN bitnami-pkg unpack php-5.6.40-1 --checksum 279d2f7f341483fe76065edd891978998c8aa63fea72abef7e0e31330c3750e2
RUN mkdir -p /bitnami && ln -sf /bitnami/php /bitnami/php-fpm
RUN cp /opt/bitnami/php/etc/php-fpm.d/www.conf.default /opt/bitnami/php/etc/php-fpm.d/www.conf

COPY rootfs /
ENV BITNAMI_APP_NAME="php-fpm" \
    BITNAMI_IMAGE_VERSION="5.6.40-rhel-7-r8" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/php/sbin:$PATH"

EXPOSE 9000

WORKDIR /app
USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "php-fpm", "-F", "--pid", "/opt/bitnami/php/tmp/php-fpm.pid", "-y", "/opt/bitnami/php/etc/php-fpm.conf" ]
