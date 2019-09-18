FROM bitnami/minideb-extras:stretch-r480
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu57 libidn11 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmcrypt4 libmemcached11 libmemcachedutil2 libncurses5 libnettle6 libnghttp2-14 libp11-kit0 libpcre3 libpng16-16 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.0.2 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5 libtinfo5 libunistring0 libuv1 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack apache-2.4.41-1 --checksum 4a3bb4e02de7df61c742b4fa57a044487e8d168da630cf84b29129f45e6e9225
RUN bitnami-pkg install redis-client-5.0.5-0 --checksum 16bf4512016b4c458cd4e42d2cb18641678674a8bdf6152856b1374b20d5baa7
RUN bitnami-pkg unpack php-7.1.32-1 --checksum cc7566f3a1ee887ffdb9bf8d8c101369b161c57e004e5bef225f9df8ba972379
RUN bitnami-pkg install mysql-client-10.3.18-1 --checksum 0923287dea11bd5880530ca456435e3f4c1c089bee2f8eea1dbf69821478e370
RUN bitnami-pkg install mongodb-client-4.0.12-0 --checksum e58c66cfe148818b8536f52173b91bf92ac9295e22b40e114bff2bb92bf57584
RUN bitnami-pkg install libphp-7.1.32-0 --checksum 60915a007f2a55786cdc371fa2cc9c511912f1f294be0fbb0c6fc1faec75ae76
RUN bitnami-pkg unpack dreamfactory-3.0.1-0 --checksum df6b9bf059e291a77d6cfe9d0c1049138f7f2502dcbac7342f9e2f5334596177
RUN ln -sf /dev/stdout /opt/bitnami/apache/logs/access_log
RUN ln -sf /dev/stderr /opt/bitnami/apache/logs/error_log

COPY rootfs /
ENV APACHE_HTTPS_PORT_NUMBER="" \
    APACHE_HTTP_PORT_NUMBER="" \
    APACHE_SET_HTTPS_PORT="no" \
    APACHE_SET_HTTP_PORT="no" \
    BITNAMI_APP_NAME="dreamfactory" \
    BITNAMI_IMAGE_VERSION="3.0.1-debian-9-r29" \
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

VOLUME [ "/certs" ]

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "httpd", "-f", "/opt/bitnami/apache/conf/httpd.conf", "-DFOREGROUND" ]
