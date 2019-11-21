FROM bitnami/oraclelinux-extras:7-r537
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib freetds-libs freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack php-7.3.11-0 --checksum 88001699b01c3677a29c36a865db155d36d7cac6df0173934d43b952b3e0714a
RUN bitnami-pkg install node-8.16.2-2 --checksum 05e0487770eed42a24072bbaf2476f8b6a69bd8bb0f10b61d9ba5dadc1e3ee67
RUN bitnami-pkg install laravel-6.4.0-0 --checksum 1ddf1a91223eec388794c8ac30b253a35fcfb9d11769aa99793a780333a4149f
RUN mkdir /app && chown bitnami:bitnami /app

COPY rootfs /
ENV BITNAMI_APP_NAME="laravel" \
    BITNAMI_IMAGE_VERSION="6.4.0-ol-7-r29" \
    NODE_PATH="/opt/bitnami/node/lib/node_modules" \
    PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/node/bin:/opt/bitnami/laravel/bin:$PATH"

EXPOSE 3000

WORKDIR /app
USER bitnami
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "php", "artisan", "serve", "--host=0.0.0.0", "--port=3000" ]
