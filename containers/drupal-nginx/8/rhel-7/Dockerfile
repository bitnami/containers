FROM registry.rhc4tp.openshift.com/bitnami/rhel-extras-7:latest
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    BITNAMI_PKG_EXTRA_DIRS="/bitnami/nginx/conf" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages wget apr apr-util bzip2-libs glibc libcom_err libcurl expat libffi freetype libgcc libgcrypt gmp gnutls libgpg-error cyrus-sasl-gssapi libicu libidn libjpeg-turbo krb5-libs keyutils-libs openldap xz-libs libtomcrypt ncurses-libs nettle p11-kit pcre2 libpng libpng12 readline cyrus-sasl-lib libssh2 openssl-libs libstdc++ libtasn1 libuuid libxml2 libxslt zlib
RUN bitnami-pkg unpack nginx-1.14.0-5 --checksum 9bd2b1045d82829c5bbe1b286a43e11b6a0e1e19c5c34b7ad20b8df5bab2ca71
RUN bitnami-pkg unpack php-5.6.38-2 --checksum 03ae59ec97f59c6b7f9c3043fff8b4485b6ad75502de492b46da7ab2a447025d
RUN bitnami-pkg unpack mysql-client-10.1.37-0 --checksum a30c54095ffb4d9180f53d925a67e4b7e11523e48b67f2d5912c20d80a703f52
RUN bitnami-pkg unpack drupal-8.6.3-0 --checksum 7ad51731f1bfbb2b98f1f5f8ff994a30e318f537f523de59f80023b5c97ec446
RUN ln -sf /dev/stdout /opt/bitnami/nginx/logs/access.log
RUN ln -sf /dev/stdout /opt/bitnami/nginx/logs/error.log

# TODO: Fix for htaccess issue
RUN mkdir -p /bitnami/nginx/conf/vhosts && chmod -R g+rwX /bitnami/nginx/conf

COPY rootfs /
COPY drupal-vhosts.conf /bitnami/nginx/conf/vhosts/

ENV ALLOW_EMPTY_PASSWORD="no" \
    NGINX_DAEMON_GROUP="" \
    NGINX_DAEMON_USER="" \
    NGINX_HTTPS_PORT_NUMBER="8443" \
    NGINX_HTTP_PORT_NUMBER="8080" \
    BITNAMI_APP_NAME="drupal" \
    BITNAMI_IMAGE_VERSION="8.6.3-r0" \
    DRUPAL_DATABASE_NAME="bitnami_drupal" \
    DRUPAL_DATABASE_PASSWORD="" \
    DRUPAL_DATABASE_USER="bn_drupal" \
    DRUPAL_EMAIL="user@example.com" \
    DRUPAL_PASSWORD="bitnami" \
    DRUPAL_USERNAME="user" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    PATH="/opt/bitnami/nginx/sbin:/opt/bitnami/php/bin:/opt/bitnami/mysql/bin:/opt/bitnami/drupal/vendor/bin:$PATH"

EXPOSE 8080 8443

USER 1001

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
