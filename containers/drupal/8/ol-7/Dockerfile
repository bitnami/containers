FROM bitnami/oraclelinux-extras:7-r45
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetds freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmcrypt libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.34-0 --checksum f12a3f629bf81de53f549eadbc6af8a24722c9b1f1b5da7da0b953fd3a40b236
RUN bitnami-pkg unpack php-7.1.20-0 --checksum b0a068074b24fd0e7e6cd62f4b1dcbdd7bb26091479eaa31ed59f65d3d44477e
RUN bitnami-pkg unpack mysql-client-10.1.34-0 --checksum 012f1f222898565b55f7d4522514c7c130d2bfe4c988754eed658ef6dafa980c
RUN bitnami-pkg install libphp-7.1.20-0 --checksum e6de4d5e2fc165cfa2c71c70826ca71bf60ed2816c2d1708fe0a4bd974d9e9cf
RUN bitnami-pkg unpack drupal-8.5.5-1 --checksum f25aa919bcfcfe0db6358d17a9f3a0a763e314256037cf643c4040c4ef17a1b0

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="drupal" \
    BITNAMI_IMAGE_VERSION="8.5.5-ol-7-r17" \
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

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["./run.sh"]
