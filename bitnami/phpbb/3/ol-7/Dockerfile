FROM bitnami/oraclelinux-extras:7-r571
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetds-libs freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libnghttp2 libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.41-3 --checksum 30ae9f98466bc180ec5b3121b000e0a8ee36ee3434d4645c7c3aa22710cc6166
RUN bitnami-pkg unpack php-7.2.26-0 --checksum 8a6d5adeb4cbb51b17809ccd57c005ff2148a4c4086d99ace2bd938646874d07
RUN bitnami-pkg unpack mysql-client-10.3.21-0 --checksum 9e012f0e449a963c923c8ea7a5cc2ab2c688564ed910eaab2aef1ad70c5d8e4b
RUN bitnami-pkg install libphp-7.2.26-1 --checksum 281ffbacd688a30cd2a902b8edc890d14141f53a9fc5a0dc9560780558baaa12
RUN bitnami-pkg unpack phpbb-3.2.8-0 --checksum ae67d387a5d9ecb2eec0816ceb4a2c78897a0545d83b9e70c9499a87329afa3b

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="phpbb" \
    BITNAMI_IMAGE_VERSION="3.2.8-ol-7-r92" \
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
