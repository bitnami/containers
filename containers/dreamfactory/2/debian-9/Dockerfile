FROM bitnami/minideb-extras:stretch-r453
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu57 libidn11 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmcrypt4 libmemcached11 libmemcachedutil2 libncurses5 libnettle6 libnghttp2-14 libp11-kit0 libpcre3 libpng16-16 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.0.2 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5 libtinfo5 libunistring0 libuv1 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack apache-2.4.41-0 --checksum fff3848b005264ae25caa93cf3dae84b263619eb028837edf3f7e480a3254fd1
RUN bitnami-pkg install redis-client-5.0.5-0 --checksum 16bf4512016b4c458cd4e42d2cb18641678674a8bdf6152856b1374b20d5baa7
RUN bitnami-pkg unpack php-7.1.31-0 --checksum aa4c056e4a7f70024de891790e2698527ca9b11b974dd80d0138489aa92424c9
RUN bitnami-pkg install mysql-client-10.3.17-0 --checksum 71d59fafc3e7e3e598af0c2b6788d77558630afe647ec1f922ffdd5025f3d737
RUN bitnami-pkg install mongodb-client-4.0.12-0 --checksum e58c66cfe148818b8536f52173b91bf92ac9295e22b40e114bff2bb92bf57584
RUN bitnami-pkg install libphp-7.1.31-1 --checksum 1b79706cccf3a98b4d921417dea9fda9b5ae105d6bb449557567b8fbc4ae2f6b
RUN bitnami-pkg unpack dreamfactory-2.14.2-0 --checksum 556f2a6a071fedb05c05186257dd68d8b3936629c04d497c8d197752803adcad
RUN ln -sf /dev/stdout /opt/bitnami/apache/logs/access_log
RUN ln -sf /dev/stderr /opt/bitnami/apache/logs/error_log

COPY rootfs /
ENV APACHE_HTTPS_PORT_NUMBER="" \
    APACHE_HTTP_PORT_NUMBER="" \
    APACHE_SET_HTTPS_PORT="no" \
    APACHE_SET_HTTP_PORT="no" \
    BITNAMI_APP_NAME="dreamfactory" \
    BITNAMI_IMAGE_VERSION="2.14.2-debian-9-r57" \
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
