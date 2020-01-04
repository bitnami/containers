FROM bitnami/oraclelinux-extras:7-r584
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages bzip2-libs cronie cyrus-sasl-lib expat freetds-libs freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libnghttp2 libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.41-4 --checksum f776f87e3c54a2ff1e13ed75de39356df465b53ac3264a94c3d6ad9252f5b682
RUN bitnami-pkg unpack php-7.2.26-0 --checksum 8a6d5adeb4cbb51b17809ccd57c005ff2148a4c4086d99ace2bd938646874d07
RUN bitnami-pkg unpack mysql-client-10.2.30-0 --checksum e05168d0d2ce16b2909860720b0dea096b4ae6b0e3afd9721f78948f0bb46593
RUN bitnami-pkg install libphp-7.2.26-2 --checksum 944622a5febae818731a82cec90d998fb0f9929734d79b70eae6919fb65ec98e
RUN bitnami-pkg unpack magento-2.3.3-0 --checksum a85d1c466bf6c73bf352b0d94b8cb23709d2f7a4c0e565573226fc79006958bc
RUN find /opt/bitnami/magento/htdocs -type d -print0 | xargs -0 chmod 775 && find /opt/bitnami/magento/htdocs -type f -print0 | xargs -0 chmod 664 && chown -R bitnami:daemon /opt/bitnami/magento/htdocs

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="magento" \
    BITNAMI_IMAGE_VERSION="2.3.3-ol-7-r88" \
    ELASTICSEARCH_HOST="" \
    ELASTICSEARCH_PORT_NUMBER="" \
    EXTERNAL_HTTPS_PORT_NUMBER="443" \
    EXTERNAL_HTTP_PORT_NUMBER="80" \
    MAGENTO_ADMINURI="admin" \
    MAGENTO_DATABASE_NAME="bitnami_magento" \
    MAGENTO_DATABASE_PASSWORD="" \
    MAGENTO_DATABASE_USER="bn_magento" \
    MAGENTO_EMAIL="user@example.com" \
    MAGENTO_FIRSTNAME="FirstName" \
    MAGENTO_HOST="127.0.0.1" \
    MAGENTO_LASTNAME="LastName" \
    MAGENTO_MODE="developer" \
    MAGENTO_PASSWORD="bitnami1" \
    MAGENTO_USERNAME="user" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:/opt/bitnami/magento/bin:$PATH"

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
