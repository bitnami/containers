FROM bitnami/oraclelinux-extras:7-r567
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetds-libs freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libnghttp2 libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.41-3 --checksum 30ae9f98466bc180ec5b3121b000e0a8ee36ee3434d4645c7c3aa22710cc6166
RUN bitnami-pkg unpack php-7.3.12-1 --checksum c809d01cf8f4542d340dda697674e919a4e96f95c5e409551a21562bc9446afe
RUN bitnami-pkg unpack mysql-client-10.1.43-0 --checksum eb30f14e1bc364fea5fc47b0d17d4a1cb506b89339c4e88b0f9f0c879dd99434
RUN bitnami-pkg install libphp-7.3.12-0 --checksum fc2975089347f4f0b2e6bf404870234bf3e2be7747030f00b061456b49a1445c
RUN bitnami-pkg unpack joomla-3.9.14-0 --checksum b7e555a5f097b9ac7af6b2269fb8c8cbc3fd345bdff9cc8fa1d33d3fe2cd2e7a

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="joomla" \
    BITNAMI_IMAGE_VERSION="3.9.14-ol-7-r1" \
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
