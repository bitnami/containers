FROM bitnami/oraclelinux-extras:7-r530
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetds-libs freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libnghttp2 libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.41-2 --checksum bf50a12c033c1ff0e1cb7696cc1abd29a132cc1c5225e9d2fdbb3c6584e349fe
RUN bitnami-pkg unpack php-7.3.11-0 --checksum 88001699b01c3677a29c36a865db155d36d7cac6df0173934d43b952b3e0714a
RUN bitnami-pkg unpack mysql-client-10.1.43-0 --checksum eb30f14e1bc364fea5fc47b0d17d4a1cb506b89339c4e88b0f9f0c879dd99434
RUN bitnami-pkg install libphp-7.3.11-0 --checksum 5b7787ea570a3e71512d1b307c45ee7c9724d74363bd9862161bbaa196804e78
RUN bitnami-pkg unpack joomla-3.9.13-0 --checksum 0d9940fe4b0e01349e1d9e65f0f2463a48830776e2d432a61e162b9ccfb20a84

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="joomla" \
    BITNAMI_IMAGE_VERSION="3.9.13-ol-7-r11" \
    JOOMLA_DATABASE_NAME="bitnami_joomla" \
    JOOMLA_DATABASE_PASSWORD="" \
    JOOMLA_DATABASE_USER="bn_joomla" \
    JOOMLA_EMAIL="user@example.com" \
    JOOMLA_FIRST_NAME="User" \
    JOOMLA_LAST_NAME="Name" \
    JOOMLA_PASSWORD="bitnami" \
    JOOMLA_USERNAME="user" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:/opt/bitnami/joomla/bin:$PATH" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_PROTOCOL="tls" \
    SMTP_USER=""

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "apache" ]
