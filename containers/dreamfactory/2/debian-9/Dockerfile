FROM bitnami/minideb-extras:stretch-r196
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu57 libidn11 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmcrypt4 libmemcached11 libmemcachedutil2 libncurses5 libnettle6 libnghttp2-14 libp11-kit0 libpcap0.8 libpcre3 libpng16-16 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.0.2 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5 libtinfo5 libunistring0 libuv1 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack apache-2.4.37-1 --checksum 5b12f889e29303b3979c44a08f4189631da56b1198ace4bcc9f63de85bce3047
RUN bitnami-pkg install redis-client-4.0.11-2 --checksum cd23f28ac660a179d25d238d5d74958d577b8b91c877954a805f54fc1e13eb91
RUN bitnami-pkg unpack php-7.1.24-1 --checksum 615044f8d1b1f90aae6ab6a14eadae61fed0e79e73d6980f58a84bc7b8ce1ce7
RUN bitnami-pkg install mysql-client-10.2.18-1 --checksum b7075d312c4b963d781f9f52d64db601c0f16beed538b85fa5f83fac09c71890
RUN bitnami-pkg install mongodb-client-3.6.8-0 --checksum a677064910e00fdf3289720ce77ec130eda12aceb058ee7526a1523b7bdf178b
RUN bitnami-pkg unpack libphp-7.1.24-0 --checksum 8aacb73f172179da93d7fa2dcbf088d9766a91225c88291dccc6900b550fac92
RUN bitnami-pkg unpack dreamfactory-2.14.1-2 --checksum 3ffc5993b202c22e58b426e6ddd456084d94ed6dcf11f00d7c91e6b4f9a9263f
RUN mkdir -p /opt/bitnami/apache/tmp && chmod g+rwX /opt/bitnami/apache/tmp
RUN ln -sf /dev/stdout /opt/bitnami/apache/logs/access_log
RUN ln -sf /dev/stderr /opt/bitnami/apache/logs/error_log

COPY rootfs /
ENV APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="dreamfactory" \
    BITNAMI_IMAGE_VERSION="2.14.1-debian-9-r37" \
    MARIADB_HOST="mariadb" \
    MARIADB_PASSWORD="" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_USER="root" \
    MONGODB_HOST="mongodb" \
    MONGODB_PASSWORD="" \
    MONGODB_PORT_NUMBER="27017" \
    MONGODB_USER="" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/redis/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:/opt/bitnami/mongodb/bin:$PATH" \
    REDIS_HOST="redis" \
    REDIS_PASSWORD="" \
    REDIS_PORT_NUMBER="6379" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_PROTOCOL="" \
    SMTP_USER=""

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "httpd", "-f", "/bitnami/apache/conf/httpd.conf", "-DFOREGROUND" ]
