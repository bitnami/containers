FROM bitnami/oraclelinux-extras:7-r345
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetds freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmcrypt libmemcached libnghttp2 libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.39-1 --checksum 7f435021b5146a191298f8c161f13582ff449e2f8a7e0d9c2c46cfb2c43171f8
RUN bitnami-pkg unpack php-7.1.29-0 --checksum 5a0aefb353b003d4d0cd83601c5c8d20e552ddee27ca8a7b54fe66117a6335bd
RUN bitnami-pkg unpack mysql-client-10.3.15-0 --checksum 8200bab1521dde4a6c377789abdff7f4b30d64843a4a78affb319f833f9f260f
RUN bitnami-pkg unpack libphp-7.1.29-0 --checksum f78176fb7260ee165cddfc76d744ba3984360a11481b09632d4117ad16ad0c41
RUN bitnami-pkg unpack drupal-8.7.2-0 --checksum b7f6c3c0b63e9985cde7e9a08c064f68c48ae5f7b40c033c3a02c44257b587c7
RUN mkdir -p /opt/bitnami/apache/tmp && chmod g+rwX /opt/bitnami/apache/tmp
RUN ln -sf /dev/stdout /opt/bitnami/apache/logs/access_log
RUN ln -sf /dev/stderr /opt/bitnami/apache/logs/error_log

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="drupal" \
    BITNAMI_IMAGE_VERSION="8.7.2-ol-7-r0" \
    DRUPAL_DATABASE_NAME="bitnami_drupal" \
    DRUPAL_DATABASE_PASSWORD="" \
    DRUPAL_DATABASE_USER="bn_drupal" \
    DRUPAL_EMAIL="user@example.com" \
    DRUPAL_HTTPS_PORT="443" \
    DRUPAL_HTTP_PORT="80" \
    DRUPAL_PASSWORD="bitnami" \
    DRUPAL_PROFILE="standard" \
    DRUPAL_USERNAME="user" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:/opt/bitnami/drupal/vendor/bin:$PATH"

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "httpd", "-f", "/bitnami/apache/conf/httpd.conf", "-DFOREGROUND" ]
