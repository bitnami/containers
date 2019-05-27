FROM bitnami/minideb-extras:stretch-r372
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libbz2-1.0 libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu57 libidn11 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmcrypt4 libmemcached11 libmemcachedutil2 libncurses5 libnettle6 libnghttp2-14 libp11-kit0 libpcre3 libpng16-16 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.0.2 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5 libtinfo5 libunistring0 libuv1 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack apache-2.4.39-1 --checksum 8b191adc55155e604cc224309a0179585f898dff83a470272d5fa5cbefc4c17e
RUN bitnami-pkg install redis-client-5.0.5-0 --checksum 16bf4512016b4c458cd4e42d2cb18641678674a8bdf6152856b1374b20d5baa7
RUN bitnami-pkg unpack php-7.1.29-0 --checksum cd0fba56de5fc1fa5c3d4eb5ef85bcd613cf0875fefe37beaddc9327f5cd7d8e
RUN bitnami-pkg install mysql-client-10.3.15-0 --checksum eb269ede06f5e5ed64dfe3515784f2c942a944c6f32c3ff030bebd5a134a50c0
RUN bitnami-pkg install mongodb-client-4.0.9-0 --checksum 64d61698e3e477cd156a874aaf976974efbb412cc0e324fa994de832e2ed1664
RUN bitnami-pkg unpack libphp-7.1.29-0 --checksum cd6c0c8fdd006dcb730cc4fe3c42420c00f2db9641353be735b8e29f579c34f8
RUN bitnami-pkg unpack dreamfactory-2.14.1-20 --checksum de247f6c455feefe15f5a3c2700c5e91259be7f06c06a12e49e952c0a0229686
RUN mkdir -p /opt/bitnami/apache/tmp && chmod g+rwX /opt/bitnami/apache/tmp
RUN ln -sf /dev/stdout /opt/bitnami/apache/logs/access_log
RUN ln -sf /dev/stderr /opt/bitnami/apache/logs/error_log

COPY rootfs /
ENV APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="dreamfactory" \
    BITNAMI_IMAGE_VERSION="2.14.1-debian-9-r190" \
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
