FROM bitnami/oraclelinux-extras:7-r116
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetds freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmcrypt libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.35-0 --checksum 5d3d1836c2ff00e299779b9f5ad90f65e599655b6a96908c579966d206bb4396
RUN bitnami-pkg unpack php-7.0.32-1 --checksum e4dc53e7136006e86064102fea76ffe2f3ac357c48ff7393eb3047fd82ae05b6
RUN bitnami-pkg unpack mysql-client-10.1.36-0 --checksum 066d5ea1a684175a9a9709a0d7d1585067324f58bcd8a569d1fd8e61028dc71b
RUN bitnami-pkg install libphp-7.0.32-2 --checksum a9477d2211a4d63d3894d43767c796305e55b196182223d1ad986455f1daf1de
RUN bitnami-pkg unpack prestashop-1.7.4-2-0 --checksum 3e5e30672c80d7752fa00631c558b50eebf87acb400dd6507b711025f57a6eb8

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="prestashop" \
    BITNAMI_IMAGE_VERSION="1.7.4-2-ol-7-r51" \
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
    PRESTASHOP_DATABASE_NAME="bitnami_prestashop" \
    PRESTASHOP_DATABASE_PASSWORD="" \
    PRESTASHOP_DATABASE_USER="bn_prestashop" \
    PRESTASHOP_EMAIL="user@example.com" \
    PRESTASHOP_FIRST_NAME="Bitnami" \
    PRESTASHOP_HOST="" \
    PRESTASHOP_LAST_NAME="User" \
    PRESTASHOP_PASSWORD="bitnami" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_PROTOCOL="" \
    SMTP_USER=""

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "apache" ]
