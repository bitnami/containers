FROM bitnami/oraclelinux-extras:7-r586
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetds-libs freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmcrypt libmemcached libnghttp2 libpng libselinux libssh2 libstdc++ libtasn1 libtidy libuv libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.41-4 --checksum f776f87e3c54a2ff1e13ed75de39356df465b53ac3264a94c3d6ad9252f5b682
RUN bitnami-pkg install redis-client-5.0.7-0 --checksum 1fb70d37880e4b45f3197ca895f5b12be0670ee5c8e2f658eebfe7d3131ffb9f
RUN bitnami-pkg unpack php-7.1.33-2 --checksum 1f180c82f1583db9d54192e42c9f422d9a107e599e4647a31c9f24a890217e8d
RUN bitnami-pkg install mysql-client-10.3.21-0 --checksum 9e012f0e449a963c923c8ea7a5cc2ab2c688564ed910eaab2aef1ad70c5d8e4b
RUN bitnami-pkg install mongodb-client-4.0.14-0 --checksum 26d1f8800df81bb045f4b1737a951edde2642176d0a34560def6c6f372a0448b
RUN bitnami-pkg install libphp-7.1.33-3 --checksum 498019846d6b88798ffd90f841e58ec0e63e890a0c57bdaa25d76dcb71c4092b
RUN bitnami-pkg unpack dreamfactory-3.0.1-0 --checksum 4adfec9855b36206a047c8436eed1899027f15231944471582cb9172cc5dc8a1

COPY rootfs /
ENV BITNAMI_APP_NAME="dreamfactory" \
    BITNAMI_IMAGE_VERSION="3.0.1-ol-7-r143" \
    MARIADB_HOST="mariadb" \
    MARIADB_PASSWORD="" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_USER="root" \
    MONGODB_HOST="mongodb" \
    MONGODB_PASSWORD="" \
    MONGODB_PORT_NUMBER="27017" \
    MONGODB_USER="" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/redis/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:/opt/bitnami/mongodb/bin:$PATH" \
    REDIS_HOST="redis" \
    REDIS_PASSWORD="" \
    REDIS_PORT_NUMBER="6379" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_PROTOCOL="" \
    SMTP_USER=""

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "apache" ]
