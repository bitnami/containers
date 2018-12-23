FROM registry.rhc4tp.openshift.com/bitnami/rhel-extras-7:latest
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    BITNAMI_PKG_EXTRA_DIRS="/bitnami/apache/conf /opt/bitnami/apache/tmp /opt/bitnami/apache/conf" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetype glibc gmp keyutils-libs krb5-libs libcom_err libcurl libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libpng libselinux libssh2 libstdc++ libxml2 libxslt ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.37-21 --checksum b7ae0764960ad19d6272b2b97b4fd48c16bf3c424cccd8342ab28064ce8072b8
RUN bitnami-pkg unpack php-7.2.13-1 --checksum 0ec313e0bf9315492f9466487b478da338ce3c58f27e57f8141a103e330681ee
RUN bitnami-pkg install wp-cli-2.1.0-0 --checksum 054d17c151d0b4b4fbb119eac077889f090c3572b3fe8e44584ff4ffb5e15a54
RUN bitnami-pkg unpack mysql-client-10.1.37-21 --checksum 0a7e787e823d7c416eabf3fe66e3f6e9c6702c84c07241de2dffebbcb96d9172
RUN bitnami-pkg unpack libphp-7.2.13-20 --checksum 690e34c0f45489ff8ca43fe9e8cc67ff8b6d9a1b0ea552fea88604afbb8d7e8e
RUN bitnami-pkg unpack wordpress-5.0.2-0 --checksum 12a54676f3ea7622461401aaec9a766850435128a5af9a624e3d68cf7001ded7
RUN ln -sf /dev/stdout /opt/bitnami/apache/logs/access_log
RUN ln -sf /dev/stdout /opt/bitnami/apache/logs/error_log

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    APACHE_HTTPS_PORT_NUMBER="8443" \
    APACHE_HTTP_PORT_NUMBER="8080" \
    BITNAMI_APP_NAME="wordpress" \
    BITNAMI_IMAGE_VERSION="5.0.2-rhel-7-r4" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/wp-cli/bin:/opt/bitnami/mysql/bin:$PATH" \
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
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
