FROM bitnami/minideb-extras:stretch-r453
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu57 libidn11 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmemcached11 libmemcachedutil2 libncurses5 libnettle6 libnghttp2-14 libp11-kit0 libpcre3 libpng16-16 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.0.2 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5 libtinfo5 libunistring0 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack apache-2.4.41-0 --checksum fff3848b005264ae25caa93cf3dae84b263619eb028837edf3f7e480a3254fd1
RUN bitnami-pkg unpack php-7.2.21-0 --checksum f12d3ee0344ad4e3e6452a32f39cb6d61a2979bf8a7973b98b2a40c14facf63a
RUN bitnami-pkg unpack mysql-client-10.1.41-0 --checksum 6a76f3331783ab71f7afe5275ae0b82a4f859d3e11b1593940324e7963574e55
RUN bitnami-pkg install libphp-7.2.21-1 --checksum f763f19586440323724c16223aa5d27e3c2ce44438c31eee269a7cf56c627d46
RUN bitnami-pkg unpack prestashop-1.7.6-0-0 --checksum 20f8d699e24fd494994a8d4d6f09358cbdad7c188b065aece8703824b6952d42
RUN ln -sf /dev/stdout /opt/bitnami/apache/logs/access_log
RUN ln -sf /dev/stderr /opt/bitnami/apache/logs/error_log

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    APACHE_HTTPS_PORT_NUMBER="" \
    APACHE_HTTP_PORT_NUMBER="" \
    APACHE_SET_HTTPS_PORT="no" \
    APACHE_SET_HTTP_PORT="no" \
    BITNAMI_APP_NAME="prestashop" \
    BITNAMI_IMAGE_VERSION="1.7.6-0-debian-9-r38" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:/opt/bitnami/prestashop/bin:$PATH" \
    PRESTASHOP_COOKIE_CHECK_IP="yes" \
    PRESTASHOP_COUNTRY="us" \
    PRESTASHOP_DATABASE_NAME="bitnami_prestashop" \
    PRESTASHOP_DATABASE_PASSWORD="" \
    PRESTASHOP_DATABASE_USER="bn_prestashop" \
    PRESTASHOP_EMAIL="user@example.com" \
    PRESTASHOP_FIRST_NAME="Bitnami" \
    PRESTASHOP_HOST="" \
    PRESTASHOP_LANGUAGE="en" \
    PRESTASHOP_LAST_NAME="User" \
    PRESTASHOP_PASSWORD="bitnami1" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_PROTOCOL="" \
    SMTP_USER=""

VOLUME [ "/certs" ]

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "httpd", "-f", "/opt/bitnami/apache/conf/httpd.conf", "-DFOREGROUND" ]
