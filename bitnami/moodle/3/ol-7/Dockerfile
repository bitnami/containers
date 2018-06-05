FROM bitnami/oraclelinux-extras:7-r5
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cronie cyrus-sasl-lib expat freetype glibc gmp keyutils-libs krb5-libs libcom_err libcurl libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmcrypt libpng libselinux libssh2 libstdc++ libxml2 libxslt ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.33-4 --checksum 4e8daac4fc3f70870a856be2dbabe35c060bae4319da105a1cd38ea2335cc5a1
RUN bitnami-pkg unpack php-7.1.18-1 --checksum 9e0599d1248382244909ab13ac306908449a5244866906d10cb08c7540359a56
RUN bitnami-pkg unpack mysql-client-10.1.33-0 --checksum 250e5cd0f6f256fb39e8d8b703856dbc0257f3da9659b8565398173a3119dd9c
RUN bitnami-pkg install libphp-7.1.18-2 --checksum 1465643c9c31c1ed4c62308f3664e978da5d1034ba4cf85096ec5d80a27565ed
RUN bitnami-pkg unpack moodle-3.5.0-3 --checksum 6ccf5aa36c01903fe8f853b34746751d2025165dde27146787afa24ea82fb532

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="moodle" \
    BITNAMI_IMAGE_VERSION="3.5.0-ol-7-r2" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MOODLE_DATABASE_NAME="bitnami_moodle" \
    MOODLE_DATABASE_PASSWORD="" \
    MOODLE_DATABASE_USER="bn_moodle" \
    MOODLE_EMAIL="user@example.com" \
    MOODLE_LANGUAGE="en" \
    MOODLE_PASSWORD="bitnami" \
    MOODLE_SITENAME="New Site" \
    MOODLE_USERNAME="user" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/mysql/bin:$PATH" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_PROTOCOL="" \
    SMTP_USER=""

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
