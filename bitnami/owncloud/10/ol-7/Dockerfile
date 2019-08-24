FROM bitnami/oraclelinux-extras:7-r438
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetds freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libnghttp2 libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.41-1 --checksum 64b7880c3d0f0f9e7cde0e71496eed06d4240a90a2b6d62c2443fce54c614691
RUN bitnami-pkg unpack php-7.2.21-0 --checksum 55d7528d343ce9317fe5338b8371cdae62653ace388deb0c6d857b1636c201cc
RUN bitnami-pkg unpack mysql-client-10.3.17-0 --checksum 83fd01acb88a54d028a327870cec66bf43f57f326814a16dc4626a5171742229
RUN bitnami-pkg install libphp-7.2.21-1 --checksum c0df6a7a78ec098f83dfcc497f17ad376365fbe4d4e8440bb62159c76c837960
RUN bitnami-pkg unpack owncloud-10.2.1-0 --checksum d78fd8861f8b1058bdd2b9759148b94ceadf32af9e07e9f53d3add26299b05e0
RUN ln -sf /dev/stdout /opt/bitnami/apache/logs/access_log
RUN ln -sf /dev/stderr /opt/bitnami/apache/logs/error_log

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    APACHE_HTTPS_PORT_NUMBER="" \
    APACHE_HTTP_PORT_NUMBER="" \
    APACHE_SET_HTTPS_PORT="no" \
    APACHE_SET_HTTP_PORT="no" \
    BITNAMI_APP_NAME="owncloud" \
    BITNAMI_IMAGE_VERSION="10.2.1-ol-7-r46" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    OWNCLOUD_DATABASE_NAME="bitnami_owncloud" \
    OWNCLOUD_DATABASE_PASSWORD="" \
    OWNCLOUD_DATABASE_USER="bn_owncloud" \
    OWNCLOUD_EMAIL="user@example.com" \
    OWNCLOUD_HOST="" \
    OWNCLOUD_PASSWORD="bitnami" \
    OWNCLOUD_USERNAME="user" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:$PATH"

VOLUME [ "/certs" ]

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "httpd", "-f", "/opt/bitnami/apache/conf/httpd.conf", "-DFOREGROUND" ]
