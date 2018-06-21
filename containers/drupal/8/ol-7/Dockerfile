FROM bitnami/oraclelinux-extras:7-r13
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetds freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmcrypt libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.33-4 --checksum 4e8daac4fc3f70870a856be2dbabe35c060bae4319da105a1cd38ea2335cc5a1
RUN bitnami-pkg unpack php-7.1.18-2 --checksum 852a27db8227b8c426b6cbc1a3c67f2ae211d478cc64a21919cac8b3361ff7a8
RUN bitnami-pkg unpack mysql-client-10.1.34-0 --checksum 012f1f222898565b55f7d4522514c7c130d2bfe4c988754eed658ef6dafa980c
RUN bitnami-pkg install libphp-7.1.18-3 --checksum 15f05ddd4903b3cebff99a4e37b413a9cb855505dc868a81f7fd420050551ad7
RUN bitnami-pkg unpack drupal-8.5.4-0 --checksum 37718d0183848c345aec768f9e79b90bb9d8a5225700472d75f615e60dde1c8a

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="drupal" \
    BITNAMI_IMAGE_VERSION="8.5.4-ol-7-r1" \
    DRUPAL_DATABASE_NAME="bitnami_drupal" \
    DRUPAL_DATABASE_PASSWORD="" \
    DRUPAL_DATABASE_USER="bn_drupal" \
    DRUPAL_EMAIL="user@example.com" \
    DRUPAL_HTTPS_PORT="443" \
    DRUPAL_HTTP_PORT="80" \
    DRUPAL_PASSWORD="bitnami" \
    DRUPAL_USERNAME="user" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/mysql/bin:/opt/bitnami/drupal/vendor/bin:$PATH"

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["./run.sh"]
