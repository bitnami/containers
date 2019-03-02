FROM bitnami/oraclelinux-extras:7-r277
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib freetds freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmcrypt libmemcached libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack php-7.1.26-4 --checksum 4107361dd60b74f383a9d0a78afe49de960aa18001422e6e686c9335b2edfec4
RUN bitnami-pkg install node-8.15.1-0 --checksum f0df1bd1597227f101ef44c0242257e48332c68965d8b422a78192f6a1686f27
RUN bitnami-pkg install laravel-5.8.0-0 --checksum a214e374451c1598a621715d3fa7aa2ef1e2938c590e8c9c77496a5035370775
RUN mkdir /app && chown bitnami:bitnami /app

COPY rootfs /
ENV BITNAMI_APP_NAME="laravel" \
    BITNAMI_IMAGE_VERSION="5.8.0-ol-7-r4" \
    NODE_PATH="/opt/bitnami/node/lib/node_modules" \
    PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/node/bin:/opt/bitnami/laravel/bin:$PATH"

EXPOSE 3000

WORKDIR /app
USER bitnami
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "php", "artisan", "serve", "--host=0.0.0.0", "--port=3000" ]
