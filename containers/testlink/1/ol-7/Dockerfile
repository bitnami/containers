FROM bitnami/oraclelinux-extras:7-r322
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetds freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmcrypt libmemcached libnghttp2 libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.39-0 --checksum 0a51d798dbb0fc22750b13ab2c4f8631a12adf7b2c017e005999ddda941245af
RUN bitnami-pkg unpack php-7.1.28-0 --checksum 455e6e54b802112ee77cd96f9eb1d26e77865640a17b5e08b7ba8abd68e8a2d3
RUN bitnami-pkg unpack mysql-client-10.1.38-0 --checksum 8140732986832471cc54aede727b66729811a0fa79e6fa86c7c791ce1f513451
RUN bitnami-pkg unpack libphp-7.1.28-0 --checksum 59a6051096c076e3f7f0f4e8fbe49f78c0ba0e0e47e09ad0221e07175349cc14
RUN bitnami-pkg unpack testlink-1.9.19-0 --checksum 9745a3cbefa8b3d6cc1117ac50e082cce1c982d5a3c1305fdf8334273a0240ed

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="testlink" \
    BITNAMI_IMAGE_VERSION="1.9.19-ol-7-r78" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:$PATH" \
    SMTP_CONNECTION_MODE="" \
    SMTP_ENABLE="false" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_USER="" \
    TESTLINK_DATABASE_NAME="bitnami_testlink" \
    TESTLINK_DATABASE_PASSWORD="" \
    TESTLINK_DATABASE_USER="bn_testlink" \
    TESTLINK_EMAIL="user@example.com" \
    TESTLINK_LANGUAGE="en_US" \
    TESTLINK_PASSWORD="bitnami" \
    TESTLINK_USERNAME="user"

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "apache" ]
