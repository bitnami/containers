FROM bitnami/oraclelinux-extras:7-r183
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetds freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmcrypt libmemcached libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.37-1 --checksum 3220aa5e11f8a9914ddc3319235119b28da16c9a15ea33509feb40800d72d55b
RUN bitnami-pkg unpack php-7.1.24-2 --checksum d866d69b98bbdd90b92726a8c7004b673d1afd8c2fb08ef935997bf0895ccbc1
RUN bitnami-pkg unpack mysql-client-10.1.37-0 --checksum c1a94cb16b0325672c1c653d017f909e705a0be0efc46cc2a2a416d7e6a196da
RUN bitnami-pkg unpack libphp-7.1.24-1 --checksum 5902edafff09837a7cf975cea78dfdf2bcd98d7642e41e8ef3878ca58cb9ccb8
RUN bitnami-pkg unpack phpbb-3.2.4-0 --checksum f9a0fcd267dc5e2e1756be367fabdaa5e3e64bd9802d6d871939510ed3f7aedf

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="phpbb" \
    BITNAMI_IMAGE_VERSION="3.2.4-ol-7-r13" \
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
