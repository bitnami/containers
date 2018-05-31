FROM bitnami/oraclelinux-extras:7-r5
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib freetype glibc gmp keyutils-libs krb5-libs libcom_err libcurl libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmcrypt libpng libselinux libssh2 libstdc++ libxml2 libxslt ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre postgresql-libs readline xz-libs zlib
RUN bitnami-pkg unpack php-7.0.30-4 --checksum c86bcdf4f7d864ed94d96b5f35f1fc919d22f02b0bc7aa13147b59e30ba51d7d
RUN mkdir -p /bitnami && ln -sf /bitnami/php /bitnami/php-fpm

COPY rootfs /
ENV BITNAMI_APP_NAME="php-fpm" \
    BITNAMI_IMAGE_VERSION="7.0.30-ol-7-r1" \
    PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:$PATH"

EXPOSE 9000

WORKDIR /app
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["php-fpm","-F","--pid","/opt/bitnami/php/tmp/php-fpm.pid","-y","/opt/bitnami/php/etc/php-fpm.conf"]
