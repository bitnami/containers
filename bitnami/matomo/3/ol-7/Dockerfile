FROM bitnami/oraclelinux-extras:7-r3
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetype glibc gmp keyutils-libs krb5-libs libcom_err libcurl libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libpng libselinux libssh2 libstdc++ libxml2 libxslt ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.33-3 --checksum 0611709446389dbf1b9a08ee4b8b447443e356e286a9c6dee312d55f72e465d6
RUN bitnami-pkg unpack php-7.0.30-3 --checksum 1de72790ae78f941b400212bba9f04201373b7573e679818a7f06edbb65cf473
RUN bitnami-pkg unpack mysql-client-10.1.33-0 --checksum 250e5cd0f6f256fb39e8d8b703856dbc0257f3da9659b8565398173a3119dd9c
RUN bitnami-pkg install libphp-7.0.30-6 --checksum 31cf8fe7e06aee8a9954e5205b9d49e7ec8c8eef4d260a9ed21e1955ec10a9f9
RUN bitnami-pkg unpack matomo-3.5.0-0 --checksum b0e2fc7aba0a061e5eef54ed88feb0f3f9aee51d838d82b2901e6e6f401a0e25

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="matomo" \
    BITNAMI_IMAGE_VERSION="3.5.0-ol-7-r0" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MATOMO_DATABASE_NAME="bitnami_matomo" \
    MATOMO_DATABASE_PASSWORD="" \
    MATOMO_DATABASE_USER="bn_matomo" \
    MATOMO_EMAIL="user@example.com" \
    MATOMO_HOST="127.0.0.1" \
    MATOMO_PASSWORD="bitnami" \
    MATOMO_USERNAME="User" \
    MATOMO_WEBSITE_HOST="https://example.org" \
    MATOMO_WEBSITE_NAME="example" \
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
CMD ["nami","start","--foreground","apache"]
