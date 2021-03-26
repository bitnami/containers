FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/apache/bin:/opt/bitnami/redis/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/mysql/bin:/opt/bitnami/mongodb/bin:/opt/bitnami/common/bin:/opt/bitnami/dreamfactory/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libargon2-1 libaudit1 libbsd0 libbz2-1.0 libc6 libcap-ng0 libcom-err2 libcurl4 libedit2 libexpat1 libffi6 libfftw3-double3 libfontconfig1 libfreetype6 libgcc1 libgcrypt20 libglib2.0-0 libgmp10 libgnutls30 libgomp1 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjemalloc2 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblcms2-2 libldap-2.4-2 liblqr-1-0 libltdl7 liblzma5 libmagickcore-6.q16-6 libmagickwand-6.q16-6 libmcrypt4 libmemcached11 libmemcachedutil2 libncurses6 libnettle6 libnghttp2-14 libp11-kit0 libpam0g libpcre3 libpng16-16 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libsodium23 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5deb1 libtinfo6 libunistring2 libuuid1 libuv1 libwebp6 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 libxslt1.1 libzip4 procps sudo tar zlib1g
RUN /build/bitnami-user.sh
RUN /build/install-nami.sh
RUN bitnami-pkg unpack php-7.3.27-7 --checksum 6b51a7750602eebb4a3b73895f228968ac21e87a683a68fbf461a076790f8c21
RUN bitnami-pkg unpack apache-2.4.46-5 --checksum f6663ef2cd47d80d63af1da7ff319ed94afe8a825115b2f52894d799013b551c
RUN bitnami-pkg install redis-client-6.0.12-1 --checksum f5935c786e305fc61ad48140c831526b78733d1fab61cc7e7ff4d8f389f4ef12
RUN bitnami-pkg install postgresql-client-11.11.0-0 --checksum 648e3913acf696c24143dfca8081d22f655f6a70abc542f5daf3f3cd9aa8e2e9
RUN bitnami-pkg install mysql-client-10.3.28-0 --checksum 9398376ca9e2033d5bc193232e8aa9b57d91d4ccf06fa67bfa0d30ef36e44c25
RUN bitnami-pkg install mongodb-client-4.4.4-1 --checksum d937810c41b56edf50fb553c7d2e0a8bc096c11898e2d669937136e61263f3a3
RUN bitnami-pkg install libphp-7.3.27-2 --checksum 136766df799e2acb375a4b2b46eb8b7e27899287f8dd22bfd8f205d6bea3c59d
RUN bitnami-pkg install tini-0.19.0-1 --checksum 9b1f1c095944bac88a62c1b63f3bff1bb123aa7ccd371c908c0e5b41cec2528d
RUN bitnami-pkg install gosu-1.12.0-2 --checksum 4d858ac600c38af8de454c27b7f65c0074ec3069880cb16d259a6e40a46bbc50
RUN bitnami-pkg unpack dreamfactory-4.5.3-1 --checksum e7efdf0575a13669770d33373ce8fb6863015107d92f25a4a4c353caf174bb4f
RUN ln -sf /dev/stdout /opt/bitnami/apache/logs/access_log && \
    ln -sf /dev/stderr /opt/bitnami/apache/logs/error_log

COPY rootfs /
ENV APACHE_ENABLE_CUSTOM_PORTS="no" \
    APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="dreamfactory" \
    BITNAMI_IMAGE_VERSION="4.5.3-debian-10-r20" \
    DREAMFACTORY_DATABASE_TYPE="mariadb" \
    DREAMFACTORY_ENABLE_MARIADB_SERVICE="no" \
    DREAMFACTORY_ENABLE_MONGODB_SERVICE="yes" \
    DREAMFACTORY_ENABLE_POSTGRESQL_SERVICE="no" \
    MARIADB_HOST="mariadb" \
    MARIADB_PASSWORD="" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_USER="root" \
    MONGODB_HOST="mongodb" \
    MONGODB_PASSWORD="" \
    MONGODB_PORT_NUMBER="27017" \
    MONGODB_USER="" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux" \
    PHP_MEMORY_LIMIT="256M" \
    POSTGRESQL_HOST="postgresql" \
    POSTGRESQL_PASSWORD="" \
    POSTGRESQL_PORT_NUMBER="5432" \
    POSTGRESQL_USER="postgres" \
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
CMD [ "httpd", "-f", "/opt/bitnami/apache/conf/httpd.conf", "-DFOREGROUND" ]
