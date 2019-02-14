FROM registry.rhc4tp.openshift.com/bitnami/rhel-extras-7:latest
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    BITNAMI_PKG_EXTRA_DIRS="/bitnami/nginx/conf" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib freetype glibc gmp keyutils-libs krb5-libs libcom_err libcurl libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libpng libselinux libssh2 libstdc++ libxml2 libxslt ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre postgresql-libs readline xz-libs zlib
RUN bitnami-pkg unpack nginx-1.14.2-20 --checksum 10e7ce1e441ca0e949b16cb3a3f21338bd61fea074f62ad947aa135d5e824ef0
RUN bitnami-pkg unpack php-7.2.15-0 --checksum e9fb8c714093a583db893baed4ca5a9ebc130c42e3afa339bb3118d42208d902
RUN bitnami-pkg install wp-cli-2.1.0-0 --checksum 054d17c151d0b4b4fbb119eac077889f090c3572b3fe8e44584ff4ffb5e15a54
RUN bitnami-pkg unpack mysql-client-10.1.38-0 --checksum fdd44abc2ff752b759ded1a7f27e334feed2be427a5850e2d21f2d093f3fee75
RUN bitnami-pkg unpack wordpress-5.0.3-5 --checksum 6a7f9d625d078b2cc3b11a62661b53412ba2f4648fe86e39c06b4556f620b2a7
RUN mkdir -p /opt/bitnami/php/logs && chown 1001 /opt/bitnami/php/logs && \
    mkdir -p /opt/bitnami/php/tmp && chown 1001 /opt/bitnami/php/tmp && \
    ln -sf /opt/bitnami/php/etc /opt/bitnami/php/conf
RUN ln -sf /dev/stdout /opt/bitnami/nginx/logs/access.log
RUN ln -sf /dev/stderr /opt/bitnami/nginx/logs/error.log

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="wordpress-nginx" \
    BITNAMI_IMAGE_VERSION="5.0.3-rhel-7-r30" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    NAMI_PREFIX="/.nami" \
    NGINX_DAEMON_GROUP="nginx" \
    NGINX_DAEMON_USER="nginx" \
    NGINX_HTTPS_PORT_NUMBER="8443" \
    NGINX_HTTP_PORT_NUMBER="8080" \
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
    WORDPRESS_HTTPS_PORT="8443" \
    WORDPRESS_HTTP_PORT="8080" \
    WORDPRESS_LAST_NAME="LastName" \
    WORDPRESS_PASSWORD="bitnami" \
    WORDPRESS_TABLE_PREFIX="wp_" \
    WORDPRESS_USERNAME="user"

EXPOSE 8080

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "./run.sh" ]
