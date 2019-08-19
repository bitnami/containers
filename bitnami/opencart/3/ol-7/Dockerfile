FROM bitnami/oraclelinux-extras:7-r433
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetds freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libnghttp2 libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.41-0 --checksum aaef16fb8778a04e8fc1d407b37d951354dec85b142086952d6fd7223764ae8d
RUN bitnami-pkg unpack php-7.3.8-0 --checksum 0cb38be663ea54976a58f46e1dd1201727a81798b88a5c5b2163c4c39921d32d
RUN bitnami-pkg unpack mysql-client-10.3.17-0 --checksum 83fd01acb88a54d028a327870cec66bf43f57f326814a16dc4626a5171742229
RUN bitnami-pkg install libphp-7.3.8-1 --checksum 4e7b7f3b42050868ac66a7b11aae979321b65ba4599f897e80bf3daf0016f17d
RUN bitnami-pkg unpack opencart-3.0.3-2-1 --checksum d7bd381efdfcbf3441063bc4a1c60b32057295be5da2c1ad5adb9c4e084b7502
RUN ln -sf /dev/stdout /opt/bitnami/apache/logs/access_log
RUN ln -sf /dev/stderr /opt/bitnami/apache/logs/error_log

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    APACHE_HTTPS_PORT_NUMBER="" \
    APACHE_HTTP_PORT_NUMBER="" \
    APACHE_SET_HTTPS_PORT="no" \
    APACHE_SET_HTTP_PORT="no" \
    BITNAMI_APP_NAME="opencart" \
    BITNAMI_IMAGE_VERSION="3.0.3-2-ol-7-r125" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    OPENCART_DATABASE_NAME="bitnami_opencart" \
    OPENCART_DATABASE_PASSWORD="" \
    OPENCART_DATABASE_USER="bn_opencart" \
    OPENCART_EMAIL="user@example.com" \
    OPENCART_HOST="127.0.0.1" \
    OPENCART_HTTP_TIMEOUT="120" \
    OPENCART_PASSWORD="bitnami1" \
    OPENCART_USERNAME="user" \
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
