FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip jq libaudit1 libbsd0 libbz2-1.0 libc6 libcap-ng0 libcom-err2 libcurl4 libedit2 libexpat1 libffi6 libfftw3-double3 libfontconfig1 libfreetype6 libgcc1 libgcrypt20 libglib2.0-0 libgmp10 libgnutls30 libgomp1 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjemalloc2 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblcms2-2 libldap-2.4-2 liblqr-1-0 libltdl7 liblzma5 libmagickcore-6.q16-6 libmagickwand-6.q16-6 libmcrypt4 libmemcached11 libmemcachedutil2 libncurses6 libnettle6 libnghttp2-14 libonig5 libp11-kit0 libpam0g libpcre3 libpng16-16 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libsodium23 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5deb1 libtinfo6 libunistring2 libuuid1 libwebp6 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 libxslt1.1 libzip4 procps sqlite3 tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "php" "7.4.27-4" --checksum 1d56b265005b8a540acbfd6a0f903074ef0fd34b6e8fe3691bfac512383ae916
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "apache" "2.4.52-0" --checksum 90dd9776f09a61d4ed0a0c99d31fd1923639c987fe1f367e866dd31b6f6da5ca
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "redis-client" "6.0.16-1" --checksum 4098185d902ee5e264bf9ec86e27e51c59c966004750ad7bde30e16a0a5f9f3f
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "postgresql-client" "11.14.0-0" --checksum caeddf6f0a758c6575d381061fe1c14fa4a2fbe8eb2ca5d53c54a9f95690c2fe
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.4.22-0" --checksum 0f28660749aa65bc54937c37602dc9464064510ebd0a068b2a3e3be17ffab6e5
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "libphp" "7.4.27-1" --checksum 2286e3101af00eaba55cdc0aab27a0ea020582a4b1b1f3af9fbf6c4c9fc23017
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.34.1-0" --checksum 3da2501870c9c3efe8cfa47b7bba894d8d97292a5274b682af1eded3b671641b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.1-4" --checksum 9b09b8c13e726569fd846abef20228b2e29de456805994e512f3b47f74cf742d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "dreamfactory" "4.10.0-0" --checksum 046a6b0ccc6e8f73472fb71ebb8935c1821b9245727c2e5bc06b6026c95276f6
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/apache/postunpack.sh
RUN /opt/bitnami/scripts/php/postunpack.sh
RUN /opt/bitnami/scripts/apache-modphp/postunpack.sh
RUN /opt/bitnami/scripts/dreamfactory/postunpack.sh
RUN /opt/bitnami/scripts/mysql-client/postunpack.sh
RUN /opt/bitnami/scripts/php-postgresql/postunpack.sh
ENV ALLOW_EMPTY_PASSWORD="no" \
    APACHE_ENABLE_CUSTOM_PORTS="no" \
    APACHE_HTTPS_PORT_NUMBER="" \
    APACHE_HTTP_PORT_NUMBER="" \
    BITNAMI_APP_NAME="dreamfactory" \
    BITNAMI_IMAGE_VERSION="4.10.0-debian-10-r24" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    MYSQL_CLIENT_ENABLE_SSL="no" \
    MYSQL_CLIENT_SSL_CA_FILE="" \
    PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/apache/bin:/opt/bitnami/redis/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:/opt/bitnami/common/bin:/opt/bitnami/dreamfactory/bin:$PATH" \
    POSTGRESQL_CLIENT_CREATE_DATABASE_NAME="" \
    POSTGRESQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    POSTGRESQL_CLIENT_CREATE_DATABASE_USERNAME="" \
    POSTGRESQL_HOST="postgresql" \
    POSTGRESQL_PORT_NUMBER="5432" \
    POSTGRESQL_ROOT_PASSWORD="" \
    POSTGRESQL_ROOT_USER="postgres"

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/dreamfactory/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/apache/run.sh" ]
