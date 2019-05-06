FROM bitnami/oraclelinux-extras:7-r326
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib freetds freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline xz-libs zlib
RUN bitnami-pkg unpack nginx-1.16.0-6 --checksum f00a3badedab0413c7240309e1617d581724070e8c867600f27362e1bb59d825
RUN bitnami-pkg unpack php-7.2.18-0 --checksum 600c11f7d5da18441e8dcf75b5038d111028723553760f2d8bfbad2042894fd4
RUN bitnami-pkg install wp-cli-2.2.0-0 --checksum 9a4b33e6dc5457f0c5c8a16f74dc9404953fb4b7d12ee3cdcd772d6aa712623d
RUN bitnami-pkg unpack mysql-client-10.1.39-0 --checksum 7ac7efb8400917e5ac49a8a5ea22cac62f079870cda71fa432303f2303f7e533
RUN bitnami-pkg unpack wordpress-5.1.1-7 --checksum 766611bdc228a131d4a66b610da797120cce7204caca39094e70c61e99e26e1e
RUN mkdir -p /opt/bitnami/php/logs && chown daemon /opt/bitnami/php/logs && \
    mkdir -p /opt/bitnami/php/tmp && chown daemon /opt/bitnami/php/tmp && \
    ln -sf /opt/bitnami/php/etc /opt/bitnami/php/conf
RUN ln -sf /dev/stdout /opt/bitnami/nginx/logs/access.log
RUN ln -sf /dev/stderr /opt/bitnami/nginx/logs/error.log

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="wordpress-nginx" \
    BITNAMI_IMAGE_VERSION="5.1.1-ol-7-r46" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    NGINX_ENABLE_CUSTOM_PORTS="no" \
    NGINX_HTTPS_PORT_NUMBER="" \
    NGINX_HTTP_PORT_NUMBER="" \
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
