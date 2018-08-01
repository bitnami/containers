FROM gcr.io/helm-publish-ci/redhat-extras:7-r51
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    BITNAMI_PKG_EXTRA_DIRS="/bitnami/apache/conf /opt/bitnami/apache/tmp /opt/bitnami/apache/conf" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetype glibc gmp keyutils-libs krb5-libs libcom_err libcurl libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libpng libselinux libssh2 libstdc++ libxml2 libxslt ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.34-1 --checksum cdaa4e89b26534999debc5d7dc1b34d76fd42ea986e40941d276c0ad24c4016d
RUN bitnami-pkg unpack php-7.0.31-1 --checksum 1adbbe5556dfa5fdaab13c012ca11b3a3d3ed42bdf526e5e3b9ae977a55b6768
RUN bitnami-pkg unpack mysql-client-10.1.33-0 --checksum 4b07acdb7d3f6a61161414ad7f7639da8f291962e242eb257f612d18c8231501
RUN bitnami-pkg install libphp-7.0.31-0 --checksum 7a7ba0fcb2026c4269f1a64d9dce3471d111d5281a7dd34c4d7ebef99795d5d9
RUN bitnami-pkg unpack wordpress-4.9.7-2 --checksum 0223ecab4cc94237dcebec98b2e511a00d39075ca36adab6608cb41fe41ad051
RUN ln -sf /dev/stdout /opt/bitnami/apache/logs/access_log
RUN ln -sf /dev/stdout /opt/bitnami/apache/logs/error_log

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    APACHE_HTTPS_PORT_NUMBER="8443" \
    APACHE_HTTP_PORT_NUMBER="8080" \
    BITNAMI_APP_NAME="wordpress" \
    BITNAMI_IMAGE_VERSION="4.9.7-rhel-7-r2" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:$PATH" \
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
    WORDPRESS_HTTPS_PORT="8443" \
    WORDPRESS_HTTP_PORT="8080" \
    WORDPRESS_LAST_NAME="LastName" \
    WORDPRESS_PASSWORD="bitnami" \
    WORDPRESS_TABLE_PREFIX="wp_" \
    WORDPRESS_USERNAME="user"

EXPOSE 8080 8443

USER 1001
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
