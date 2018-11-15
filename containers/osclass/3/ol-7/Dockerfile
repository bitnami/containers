FROM bitnami/oraclelinux-extras:7-r168
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetds freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmcrypt libmemcached libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.37-1 --checksum 3220aa5e11f8a9914ddc3319235119b28da16c9a15ea33509feb40800d72d55b
RUN bitnami-pkg unpack php-7.1.24-1 --checksum c28f2db4764494844faeba4a401c6280fb2317e0020b0cc0551e1469ca87b5d7
RUN bitnami-pkg unpack mysql-client-10.1.37-0 --checksum c1a94cb16b0325672c1c653d017f909e705a0be0efc46cc2a2a416d7e6a196da
RUN bitnami-pkg unpack libphp-7.1.24-0 --checksum eeb762bc0bab3be32b2a62fd7df82d53be77f33756f4bbff0df77428610320c9
RUN bitnami-pkg unpack osclass-3.7.4-5 --checksum 8baddaa989b51cafdea74024de4f1e3cc51adbe967c0bddec16ab26bca1a136f
RUN mkdir -p /opt/bitnami/apache/tmp && chmod g+rwX /opt/bitnami/apache/tmp
RUN ln -sf /dev/stdout /opt/bitnami/apache/logs/access_log
RUN ln -sf /dev/stderr /opt/bitnami/apache/logs/error_log

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="osclass" \
    BITNAMI_IMAGE_VERSION="3.7.4-ol-7-r131" \
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

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "httpd", "-f", "/bitnami/apache/conf/httpd.conf", "-DFOREGROUND" ]
