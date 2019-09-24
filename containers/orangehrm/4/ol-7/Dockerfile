FROM bitnami/oraclelinux-extras:7-r476
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetds-libs freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libnghttp2 libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.41-2 --checksum bf50a12c033c1ff0e1cb7696cc1abd29a132cc1c5225e9d2fdbb3c6584e349fe
RUN bitnami-pkg unpack php-7.2.22-2 --checksum 57a218b0f376107e8e2eac7cf36d817f71dc2da7dbcb21cc10995fc020fdb9f9
RUN bitnami-pkg unpack mysql-client-10.2.27-2 --checksum 68c66c640d34436eec7077a22b3ab6a54925337dea711579c6ad9e0410908e19
RUN bitnami-pkg install libphp-7.2.22-1 --checksum 67a5567885cb6f06f149793eadde262bc8782fa02a2d436010e9fbd718d33d04
RUN bitnami-pkg unpack orangehrm-4.3.3-0-1 --checksum c14695ff5b30292b7e640d8d32d390bafe83cf08b0b14dc9b6f578a4bbb4c0dc

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="orangehrm" \
    BITNAMI_IMAGE_VERSION="4.3.3-0-ol-7-r26" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    ORANGEHRM_DATABASE_NAME="bitnami_orangehrm" \
    ORANGEHRM_DATABASE_PASSWORD="" \
    ORANGEHRM_DATABASE_USER="bn_orangehrm" \
    ORANGEHRM_PASSWORD="Bitnami.12345" \
    ORANGEHRM_USERNAME="admin" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:$PATH" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_PROTOCOL="none" \
    SMTP_USER=""

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "apache" ]
