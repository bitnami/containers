FROM bitnami/oraclelinux-extras:7-r236
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetds freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmcrypt libmemcached libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.37-24 --checksum 8d30b7cef2a3f223b59d652fdad92d84198296cd6e30c844c3ecb32ce4676b88
RUN bitnami-pkg unpack php-7.1.26-0 --checksum e00fa61ec021232fd46c9d3b2c11bc5e9c5c0fd3e8c26440befcaabe106c2717
RUN bitnami-pkg unpack mysql-client-10.1.37-21 --checksum ce01cd40ec8c9612d6a37b75f9f559f7afb4508aa5ceae5f9392aa0d42c928fc
RUN bitnami-pkg unpack libphp-7.1.26-0 --checksum 312de7a34cdf817dbea8f03c793ed01b695825e0399c4212a8dfea199f6f34bd
RUN bitnami-pkg unpack prestashop-1.7.5-0-1 --checksum 1dc9928fa55420a5103d81585d95e7d18f9afd67cee3fb1fa4e0fadde109c5e2
RUN mkdir -p /opt/bitnami/apache/tmp && chmod g+rwX /opt/bitnami/apache/tmp
RUN ln -sf /dev/stdout /opt/bitnami/apache/logs/access_log
RUN ln -sf /dev/stderr /opt/bitnami/apache/logs/error_log

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="prestashop" \
    BITNAMI_IMAGE_VERSION="1.7.5-0-ol-7-r28" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:/opt/bitnami/prestashop/bin:$PATH" \
    PRESTASHOP_COOKIE_CHECK_IP="yes" \
    PRESTASHOP_COUNTRY="us" \
    PRESTASHOP_DATABASE_NAME="bitnami_prestashop" \
    PRESTASHOP_DATABASE_PASSWORD="" \
    PRESTASHOP_DATABASE_USER="bn_prestashop" \
    PRESTASHOP_EMAIL="user@example.com" \
    PRESTASHOP_FIRST_NAME="Bitnami" \
    PRESTASHOP_HOST="" \
    PRESTASHOP_LANGUAGE="en" \
    PRESTASHOP_LAST_NAME="User" \
    PRESTASHOP_PASSWORD="bitnami" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_PROTOCOL="" \
    SMTP_USER=""

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "httpd", "-f", "/bitnami/apache/conf/httpd.conf", "-DFOREGROUND" ]
