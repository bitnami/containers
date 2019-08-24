FROM bitnami/oraclelinux-extras:7-r438
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetds freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libnghttp2 libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.41-1 --checksum 64b7880c3d0f0f9e7cde0e71496eed06d4240a90a2b6d62c2443fce54c614691
RUN bitnami-pkg unpack php-7.3.8-0 --checksum 0cb38be663ea54976a58f46e1dd1201727a81798b88a5c5b2163c4c39921d32d
RUN bitnami-pkg unpack mysql-client-10.3.17-0 --checksum 83fd01acb88a54d028a327870cec66bf43f57f326814a16dc4626a5171742229
RUN bitnami-pkg install libphp-7.3.8-1 --checksum 4e7b7f3b42050868ac66a7b11aae979321b65ba4599f897e80bf3daf0016f17d
RUN bitnami-pkg unpack osclass-3.7.4-21 --checksum 78f9e695a964f2b07bccefea8c305338bf646bbef46d342a199b60beb82b6e73
RUN ln -sf /dev/stdout /opt/bitnami/apache/logs/access_log
RUN ln -sf /dev/stderr /opt/bitnami/apache/logs/error_log

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    APACHE_HTTPS_PORT_NUMBER="" \
    APACHE_HTTP_PORT_NUMBER="" \
    APACHE_SET_HTTPS_PORT="no" \
    APACHE_SET_HTTP_PORT="no" \
    BITNAMI_APP_NAME="osclass" \
    BITNAMI_IMAGE_VERSION="3.7.4-ol-7-r409" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    OSCLASS_DATABASE_NAME="bitnami_osclass" \
    OSCLASS_DATABASE_PASSWORD="" \
    OSCLASS_DATABASE_USER="bn_osclass" \
    OSCLASS_EMAIL="user@example.com" \
    OSCLASS_HOST="127.0.0.1" \
    OSCLASS_PASSWORD="bitnami1" \
    OSCLASS_PING_ENGINES="1" \
    OSCLASS_SAVE_STATS="1" \
    OSCLASS_USERNAME="user" \
    OSCLASS_WEB_TITLE="Sample Web Page" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:$PATH" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_PROTOCOL="" \
    SMTP_USER=""

VOLUME [ "/certs" ]

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "httpd", "-f", "/opt/bitnami/apache/conf/httpd.conf", "-DFOREGROUND" ]
