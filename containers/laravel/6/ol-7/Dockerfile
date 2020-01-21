FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/node/bin:/opt/bitnami/laravel/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages bzip2-libs ca-certificates curl cyrus-sasl-lib freetds-libs freetype glibc gmp gnutls gzip hostname keyutils-libs krb5-libs libaio-devel libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs procps-ng readline sqlite sudo tar which xz-libs zlib
RUN /build/bitnami-user.sh && \
    /build/install-nami.sh
RUN bitnami-pkg unpack php-7.3.13-3 --checksum 58a34b695011b33ac78f86d2da6117f6110c76c26562a51b9741ca5a03b5b08d
RUN bitnami-pkg install node-8.17.0-0 --checksum c6720534f7fa5167debe21fb272168c98ef912b1b8c57eb50a21669b6ca16192
RUN bitnami-pkg install laravel-6.12.0-0 --checksum 2c1e7abf85e43c611ebff07649973f88aa992ef3ada6d9c2c06e974963571a64
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN mkdir /app && chown bitnami:bitnami /app
RUN /build/install-gosu.sh
RUN /build/install-tini.sh

COPY rootfs /
ENV BITNAMI_APP_NAME="laravel" \
    BITNAMI_IMAGE_VERSION="6.12.0-ol-7-r0" \
    NODE_PATH="/opt/bitnami/node/lib/node_modules"

EXPOSE 3000

WORKDIR /app
USER bitnami
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "php", "artisan", "serve", "--host=0.0.0.0", "--port=3000" ]
