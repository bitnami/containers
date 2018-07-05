FROM bitnami/oraclelinux-extras:7-r26
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib freetds freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmcrypt libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline xz-libs zlib
RUN bitnami-pkg unpack php-7.0.30-7 --checksum 5754714c3964c1ced5ed1d9c8c3f059ca59f65c400f1c9e00f655bae869bef61
RUN mkdir -p /bitnami && ln -sf /bitnami/php /bitnami/php-fpm

COPY rootfs /
ENV BITNAMI_APP_NAME="php-fpm" \
    BITNAMI_IMAGE_VERSION="7.0.30-ol-7-r17" \
    PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:$PATH"

EXPOSE 9000

WORKDIR /app
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["php-fpm","-F","--pid","/opt/bitnami/php/tmp/php-fpm.pid","-y","/opt/bitnami/php/etc/php-fpm.conf"]
