FROM bitnami/oraclelinux-extras:7-r63
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib freetds freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmcrypt libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline xz-libs zlib
RUN bitnami-pkg unpack nginx-1.14.0-2 --checksum 1f459a388d680c18a47177b7e3c50af4e0402311b6f67ae72bd4bff76b6b965e
RUN bitnami-pkg unpack php-7.0.31-1 --checksum f58969a4b2e7a6607e17bd6446c4a8e7af780d6275955c274495ac222ac81771
RUN bitnami-pkg unpack mysql-client-10.1.35-0 --checksum e8b7b1feec15c0dd8c1643eb0ab0220c384e1eb981e1ef7cd51d06bb9fb09e6e
RUN bitnami-pkg unpack wordpress-4.9.8-0 --checksum 0af2c7e45d8140124eced1571ce0dca1beb081a906f6cc88440c2132809a4e5d

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="wordpress-nginx" \
    BITNAMI_IMAGE_VERSION="4.9.8-ol-7-r4" \
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
    NGINX_HTTP_PORT_NUMBER="80" \
    PATH="/opt/bitnami/nginx/sbin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:$PATH" \
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
    WORDPRESS_HTTPS_PORT="443" \
    WORDPRESS_HTTP_PORT="80" \
    WORDPRESS_LAST_NAME="LastName" \
    WORDPRESS_PASSWORD="bitnami" \
    WORDPRESS_TABLE_PREFIX="wp_" \
    WORDPRESS_USERNAME="user"

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["./run.sh"]
