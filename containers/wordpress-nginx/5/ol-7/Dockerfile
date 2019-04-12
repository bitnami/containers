FROM bitnami/oraclelinux-extras:7-r317
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib freetds freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline xz-libs zlib
RUN bitnami-pkg unpack nginx-1.14.2-21 --checksum d4d907cc0c038a32cb7fe0d681552f469a5d6c2af51d12fe83c710f250c2e463
RUN bitnami-pkg unpack php-7.2.17-0 --checksum 027af015bcd3a9b4a898a2f191c4901831e6e31d06f9633a37a6318204055ed8
RUN bitnami-pkg install wp-cli-2.1.0-0 --checksum 536326bfad2bd930b24e8dda405ce4a27545822b5bf0e7bd8a049f3cc9641cf7
RUN bitnami-pkg unpack mysql-client-10.1.38-0 --checksum 8140732986832471cc54aede727b66729811a0fa79e6fa86c7c791ce1f513451
RUN bitnami-pkg unpack wordpress-5.1.1-3 --checksum f0e90b3c758b6d02a496817061ed44d9b1f5baa7376eb7cdd5cc27e8fe01b153
RUN mkdir -p /opt/bitnami/php/logs && chown daemon /opt/bitnami/php/logs && \
    mkdir -p /opt/bitnami/php/tmp && chown daemon /opt/bitnami/php/tmp && \
    ln -sf /opt/bitnami/php/etc /opt/bitnami/php/conf
RUN ln -sf /dev/stdout /opt/bitnami/nginx/logs/access.log
RUN ln -sf /dev/stderr /opt/bitnami/nginx/logs/error.log

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="wordpress-nginx" \
    BITNAMI_IMAGE_VERSION="5.1.1-ol-7-r33" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    NGINX_DAEMON_GROUP="daemon" \
    NGINX_DAEMON_USER="daemon" \
    NGINX_HTTPS_PORT_NUMBER="443" \
    NGINX_HTTP_PORT_NUMBER="80" \
    PATH="/opt/bitnami/nginx/sbin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/wp-cli/bin:/opt/bitnami/mysql/bin:$PATH" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_PROTOCOL="" \
    SMTP_USER="" \
    SMTP_USERNAME="" \
    WORDPRESS_BLOG_NAME="User's Blog!" \
    WORDPRESS_DATABASE_NAME="bitnami_wordpress" \
    WORDPRESS_DATABASE_PASSWORD="" \
    WORDPRESS_DATABASE_USER="bn_wordpress" \
    WORDPRESS_EMAIL="user@example.com" \
    WORDPRESS_FIRST_NAME="FirstName" \
    WORDPRESS_HOST="" \
    WORDPRESS_HTACCESS_OVERRIDE_NONE="yes" \
    WORDPRESS_HTTPS_PORT="443" \
    WORDPRESS_HTTP_PORT="80" \
    WORDPRESS_LAST_NAME="LastName" \
    WORDPRESS_PASSWORD="bitnami" \
    WORDPRESS_SKIP_INSTALL="no" \
    WORDPRESS_TABLE_PREFIX="wp_" \
    WORDPRESS_USERNAME="user"

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "./run.sh" ]
