FROM gcr.io/helm-publish-ci/redhat-extras:7-r137
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    BITNAMI_PKG_EXTRA_DIRS="/bitnami/apache/conf /opt/bitnami/apache/tmp /opt/bitnami/apache/conf" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetype glibc gmp keyutils-libs krb5-libs libcom_err libcurl libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libpng libselinux libssh2 libstdc++ libxml2 libxslt ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.35-3 --checksum d23b039917c5716088d98ce5b001d671b323aa605d15c4cbe11814fecb9b88c3
RUN bitnami-pkg unpack php-7.1.23-0 --checksum 9add08ad08b82b9533d3d625017031aa99b7259f5738d25b688e59e47ff1487f
RUN bitnami-pkg unpack mysql-client-10.1.36-1 --checksum e13014dbb969bfa2469f45694112e9b62fe886753899c8bc2cfd32705af999d9
RUN bitnami-pkg unpack libphp-7.1.23-2 --checksum 6d90c8973a114854c9c5c2e41fb323676b59ac31444721f32c87a6952517eb8e
RUN bitnami-pkg unpack drupal-8.6.2-0 --checksum d6e2e38066d4f6da36a252127912847cdc6bde2a61adc1c64aa0cec072e0d0ea
RUN ln -sf /dev/stdout /opt/bitnami/apache/logs/access_log
RUN ln -sf /dev/stdout /opt/bitnami/apache/logs/error_log

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    APACHE_HTTPS_PORT_NUMBER="8443" \
    APACHE_HTTP_PORT_NUMBER="8080" \
    BITNAMI_APP_NAME="drupal" \
    BITNAMI_IMAGE_VERSION="8.6.2-rhel-7-r0" \
    DRUPAL_DATABASE_NAME="bitnami_drupal" \
    DRUPAL_DATABASE_PASSWORD="" \
    DRUPAL_DATABASE_USER="bn_drupal" \
    DRUPAL_EMAIL="user@example.com" \
    DRUPAL_HTTPS_PORT="8443" \
    DRUPAL_HTTP_PORT="8080" \
    DRUPAL_PASSWORD="bitnami" \
    DRUPAL_PROFILE="standard" \
    DRUPAL_USERNAME="user" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:/opt/bitnami/drupal/vendor/bin:$PATH"

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "httpd", "-f", "/bitnami/apache/conf/httpd.conf", "-DFOREGROUND" ]
