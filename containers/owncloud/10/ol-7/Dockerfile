FROM bitnami/oraclelinux-extras:7-r216
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetds freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmcrypt libmemcached libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.37-21 --checksum 98587b038258e6d67135adff1d7ccf4d3d1da7168e2857c2a46fc5ee50e735b2
RUN bitnami-pkg unpack php-7.1.25-21 --checksum 1f44b05378c6e9419b663a1f6d73fb8923493386e3a3e8a5b67619a9d5e34b9b
RUN bitnami-pkg unpack mysql-client-10.1.37-21 --checksum ce01cd40ec8c9612d6a37b75f9f559f7afb4508aa5ceae5f9392aa0d42c928fc
RUN bitnami-pkg unpack libphp-7.1.25-20 --checksum b48d0d1862bd57dc614414191bb2bbb2ed610eca10f70a377b881b0e0d6fea9f
RUN bitnami-pkg unpack owncloud-10.0.10-20 --checksum 37f2b2462b35cea44561c11f0083748fdd94d689f7f5f06089016bd5c1b650cb
RUN mkdir -p /opt/bitnami/apache/tmp && chmod g+rwX /opt/bitnami/apache/tmp
RUN ln -sf /dev/stdout /opt/bitnami/apache/logs/access_log
RUN ln -sf /dev/stderr /opt/bitnami/apache/logs/error_log

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="owncloud" \
    BITNAMI_IMAGE_VERSION="10.0.10-ol-7-r104" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    OWNCLOUD_DATABASE_NAME="bitnami_owncloud" \
    OWNCLOUD_DATABASE_PASSWORD="" \
    OWNCLOUD_DATABASE_USER="bn_owncloud" \
    OWNCLOUD_EMAIL="user@example.com" \
    OWNCLOUD_HOST="" \
    OWNCLOUD_PASSWORD="bitnami" \
    OWNCLOUD_USERNAME="user" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:$PATH"

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "httpd", "-f", "/bitnami/apache/conf/httpd.conf", "-DFOREGROUND" ]
