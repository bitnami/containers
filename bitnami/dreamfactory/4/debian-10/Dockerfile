FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/apache/bin:/opt/bitnami/redis/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/mysql/bin:/opt/bitnami/mongodb/bin:/opt/bitnami/common/bin:/opt/bitnami/dreamfactory/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libaudit1 libbsd0 libbz2-1.0 libc6 libcap-ng0 libcom-err2 libcurl4 libedit2 libexpat1 libffi6 libfftw3-double3 libfontconfig1 libfreetype6 libgcc1 libgcrypt20 libglib2.0-0 libgmp10 libgnutls30 libgomp1 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjemalloc2 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblcms2-2 libldap-2.4-2 liblqr-1-0 libltdl7 liblzma5 libmagickcore-6.q16-6 libmagickwand-6.q16-6 libmcrypt4 libmemcached11 libmemcachedutil2 libncurses6 libnettle6 libnghttp2-14 libp11-kit0 libpam0g libpcre3 libpng16-16 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5deb1 libtinfo6 libunistring2 libuuid1 libuv1 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 libxslt1.1 libzip4 procps sudo tar zlib1g
RUN /build/bitnami-user.sh
RUN /build/install-nami.sh
RUN bitnami-pkg unpack php-7.3.19-0 --checksum 8799bc6c2565c4e9010756915de8f250a1f989df33794395f6ea1abc85bbf4b1
RUN bitnami-pkg unpack apache-2.4.43-4 --checksum e6929d8619f48976f9206bec14cb9634ebe8590225818eea12c27840617f53aa
RUN bitnami-pkg install redis-client-6.0.5-0 --checksum 55deb6b6eed6d980f9f5e403f0d38b52c619afa65aafefdb26e98e4fba6836b1
RUN bitnami-pkg install postgresql-client-11.8.0-1 --checksum 732f07d8a39665702c3b69883e5c6e7c601a033dbac4a896843d8cf63026bc7f
RUN bitnami-pkg install mysql-client-10.3.23-0 --checksum 7af3cead7a38670bed924fbc99e20c67f6244bb5a92642adb4ab6cd307aa9a5e
RUN bitnami-pkg install mongodb-client-4.2.8-0 --checksum ffc5223c428214307734782b8c9c10811d6d04f42ea9d3b46f02ceb6920f8baa
RUN bitnami-pkg install libphp-7.3.19-0 --checksum 9d3e785b7544f374e4943f94795625e9048a89fab109ada62552c5784c68bbbe
RUN bitnami-pkg install tini-0.19.0-0 --checksum 9a8ae20be31a518f042fcec359f2cf35bfdb4e2a56f2fa8ff9ef2ecaf45da80c
RUN bitnami-pkg install gosu-1.12.0-0 --checksum 582d501eeb6b338a24f417fededbf14295903d6be55c52d66c52e616c81bcd8c
RUN bitnami-pkg unpack dreamfactory-4.2.2-0 --checksum 6c4aee2a6c01e4f7412c440aaba6c536540e12532372404299ff95a0f1c39f92
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN ln -sf /dev/stdout /opt/bitnami/apache/logs/access_log && \
    ln -sf /dev/stderr /opt/bitnami/apache/logs/error_log

COPY rootfs /
ENV APACHE_ENABLE_CUSTOM_PORTS="no" \
    APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="dreamfactory" \
    BITNAMI_IMAGE_VERSION="4.2.2-debian-10-r33" \
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
