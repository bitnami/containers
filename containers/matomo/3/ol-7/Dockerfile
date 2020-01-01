FROM bitnami/oraclelinux-extras:7-r581
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages bzip2-libs cronie cyrus-sasl-lib expat freetds-libs freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libnghttp2 libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.41-4 --checksum f776f87e3c54a2ff1e13ed75de39356df465b53ac3264a94c3d6ad9252f5b682
RUN bitnami-pkg unpack php-7.3.13-0 --checksum a51ab66c0ae1dd1503084b35380659069ba03fe2644e2034752b346c87b3c89e
RUN bitnami-pkg unpack mysql-client-10.3.21-0 --checksum 9e012f0e449a963c923c8ea7a5cc2ab2c688564ed910eaab2aef1ad70c5d8e4b
RUN bitnami-pkg install libphp-7.3.13-2 --checksum ddba3fba1c2c84d24cbe3545222644d6c5ccc0a3e2340b03ad28c09d0f0d0c53
RUN bitnami-pkg unpack matomo-3.13.0-0 --checksum 20d68e21aaddd52fc4551c0f30e1fdf3cbf8b4304f588189f712313e3dfb3db1

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="matomo" \
    BITNAMI_IMAGE_VERSION="3.13.0-ol-7-r35" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MATOMO_DATABASE_NAME="bitnami_matomo" \
    MATOMO_DATABASE_PASSWORD="" \
    MATOMO_DATABASE_USER="bn_matomo" \
    MATOMO_EMAIL="user@example.com" \
    MATOMO_ENABLE_PROXY_URI_HEADER="no" \
    MATOMO_HOST="127.0.0.1" \
    MATOMO_PASSWORD="bitnami" \
    MATOMO_USERNAME="User" \
    MATOMO_WEBSITE_HOST="https://example.org" \
    MATOMO_WEBSITE_NAME="example" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:$PATH" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_PROTOCOL="" \
    SMTP_USER=""

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
