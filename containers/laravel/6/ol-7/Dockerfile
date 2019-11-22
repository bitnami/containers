FROM bitnami/oraclelinux-extras:7-r541
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib freetds-libs freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack php-7.3.12-0 --checksum d826f6f7b9e774271d3f9056e7710e1691f09cff4f3bb27f84b2d5ec6e223bb9
RUN bitnami-pkg install node-8.16.2-2 --checksum 05e0487770eed42a24072bbaf2476f8b6a69bd8bb0f10b61d9ba5dadc1e3ee67
RUN bitnami-pkg install laravel-6.5.2-0 --checksum 79caf7efd2f3c9a9d737c7ef3eb6736e7b1e3e7197b3221ff2e26fb2a461629a
RUN mkdir /app && chown bitnami:bitnami /app

COPY rootfs /
ENV BITNAMI_APP_NAME="laravel" \
    BITNAMI_IMAGE_VERSION="6.5.2-ol-7-r3" \
    NODE_PATH="/opt/bitnami/node/lib/node_modules" \
    PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/node/bin:/opt/bitnami/laravel/bin:$PATH"

EXPOSE 3000

WORKDIR /app
USER bitnami
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "php", "artisan", "serve", "--host=0.0.0.0", "--port=3000" ]
