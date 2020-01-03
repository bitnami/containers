FROM bitnami/oraclelinux-extras:7-r583
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetds-libs freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libnghttp2 libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.41-4 --checksum f776f87e3c54a2ff1e13ed75de39356df465b53ac3264a94c3d6ad9252f5b682
RUN bitnami-pkg unpack php-7.3.13-0 --checksum a51ab66c0ae1dd1503084b35380659069ba03fe2644e2034752b346c87b3c89e
RUN bitnami-pkg unpack mysql-client-10.3.21-0 --checksum 9e012f0e449a963c923c8ea7a5cc2ab2c688564ed910eaab2aef1ad70c5d8e4b
RUN bitnami-pkg install libphp-7.3.13-2 --checksum ddba3fba1c2c84d24cbe3545222644d6c5ccc0a3e2340b03ad28c09d0f0d0c53
RUN bitnami-pkg unpack drupal-8.8.1-1 --checksum 17c16ee526dfcc8b57345449b44a3900a92f6c70dff5b23b068208e23c08e214

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="drupal" \
    BITNAMI_IMAGE_VERSION="8.8.1-ol-7-r14" \
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
CMD [ "nami", "start", "--foreground", "apache" ]
