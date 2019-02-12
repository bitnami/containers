FROM bitnami/oraclelinux-extras:7-r259
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetds freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmcrypt libmemcached libnghttp2 libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.38-1 --checksum e1622f1e16e595c1758123c494d45adbfe7a9f40924f8181241f723cd641bb6c
RUN bitnami-pkg unpack php-7.1.26-4 --checksum 4107361dd60b74f383a9d0a78afe49de960aa18001422e6e686c9335b2edfec4
RUN bitnami-pkg unpack mysql-client-10.1.38-0 --checksum 8140732986832471cc54aede727b66729811a0fa79e6fa86c7c791ce1f513451
RUN bitnami-pkg unpack libphp-7.1.26-2 --checksum f9adbff7a4be5b375413ea57f606d7934c22771d2238c264349b24da301b6426
RUN bitnami-pkg unpack phpbb-3.2.5-0 --checksum 2e3acfb4270cff5fc602d51833f6fd3542a7d65195fc6192755a74cff568abdc

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="phpbb" \
    BITNAMI_IMAGE_VERSION="3.2.5-ol-7-r47" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:$PATH" \
    PHPBB_DATABASE_NAME="bitnami_phpbb" \
    PHPBB_DATABASE_PASSWORD="" \
    PHPBB_DATABASE_USER="bn_phpbb" \
    PHPBB_EMAIL="user@example.com" \
    PHPBB_FIRST_NAME="User" \
    PHPBB_FORUM_DESCRIPTION="A little text to describe your forum" \
    PHPBB_FORUM_NAME="My forum" \
    PHPBB_HOST="" \
    PHPBB_LAST_NAME="Name" \
    PHPBB_PASSWORD="bitnami" \
    PHPBB_USERNAME="user" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_USER=""

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "apache" ]
