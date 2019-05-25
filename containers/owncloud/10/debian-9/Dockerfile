FROM bitnami/minideb-extras:stretch-r370
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu57 libidn11 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmemcached11 libmemcachedutil2 libncurses5 libnettle6 libnghttp2-14 libp11-kit0 libpcre3 libpng16-16 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.0.2 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5 libtinfo5 libunistring0 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack apache-2.4.39-1 --checksum 8b191adc55155e604cc224309a0179585f898dff83a470272d5fa5cbefc4c17e
RUN bitnami-pkg unpack php-7.2.18-0 --checksum a537ba3e532e08ec3a3b752a27867a850f8a40082a31d58a3c221d20024c47a4
RUN bitnami-pkg unpack mysql-client-10.3.15-0 --checksum eb269ede06f5e5ed64dfe3515784f2c942a944c6f32c3ff030bebd5a134a50c0
RUN bitnami-pkg unpack libphp-7.2.18-0 --checksum 78207e62df240821ab9e6f8669ab415223b38c9c85c7e4b04b45c6fb0c9582d0
RUN bitnami-pkg unpack owncloud-10.2.0-0 --checksum 5ea6682d93133726feeb53df9c3d761d546826e35361cf485930b3cc2d17896a
RUN mkdir -p /opt/bitnami/apache/tmp && chmod g+rwX /opt/bitnami/apache/tmp
RUN ln -sf /dev/stdout /opt/bitnami/apache/logs/access_log
RUN ln -sf /dev/stderr /opt/bitnami/apache/logs/error_log

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="owncloud" \
    BITNAMI_IMAGE_VERSION="10.2.0-debian-9-r2" \
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
