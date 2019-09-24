FROM bitnami/oraclelinux-extras:7-r475
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetds-libs freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libnghttp2 libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.41-2 --checksum bf50a12c033c1ff0e1cb7696cc1abd29a132cc1c5225e9d2fdbb3c6584e349fe
RUN bitnami-pkg unpack php-7.2.22-2 --checksum 57a218b0f376107e8e2eac7cf36d817f71dc2da7dbcb21cc10995fc020fdb9f9
RUN bitnami-pkg unpack mysql-client-10.3.18-2 --checksum c9d987cf8f6f6831d04920d64598d0c77cf994235753cf4d5d18ac787c12918e
RUN bitnami-pkg install libphp-7.2.22-1 --checksum 67a5567885cb6f06f149793eadde262bc8782fa02a2d436010e9fbd718d33d04
RUN bitnami-pkg unpack owncloud-10.2.1-1 --checksum fe77f6dbccc1277155eeeb1842faa10f78b5bc86a3ba61387242edf8dedeb306

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="owncloud" \
    BITNAMI_IMAGE_VERSION="10.2.1-ol-7-r80" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    OWNCLOUD_DATABASE_NAME="bitnami_owncloud" \
    OWNCLOUD_DATABASE_PASSWORD="" \
    OWNCLOUD_DATABASE_USER="bn_owncloud" \
    OWNCLOUD_EMAIL="user@example.com" \
    OWNCLOUD_HOST="" \
    OWNCLOUD_PASSWORD="bitnami" \
    OWNCLOUD_USERNAME="user" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:$PATH"

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "apache" ]
