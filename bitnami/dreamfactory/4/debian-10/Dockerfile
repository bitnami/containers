FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/apache/bin:/opt/bitnami/redis/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/mysql/bin:/opt/bitnami/mongodb/bin:/opt/bitnami/common/bin:/opt/bitnami/dreamfactory/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libargon2-1 libaudit1 libbsd0 libbz2-1.0 libc6 libcap-ng0 libcom-err2 libcurl4 libedit2 libexpat1 libffi6 libfftw3-double3 libfontconfig1 libfreetype6 libgcc1 libgcrypt20 libglib2.0-0 libgmp10 libgnutls30 libgomp1 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjemalloc2 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblcms2-2 libldap-2.4-2 liblqr-1-0 libltdl7 liblzma5 libmagickcore-6.q16-6 libmagickwand-6.q16-6 libmcrypt4 libmemcached11 libmemcachedutil2 libncurses6 libnettle6 libnghttp2-14 libp11-kit0 libpam0g libpcre3 libpng16-16 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5deb1 libtinfo6 libunistring2 libuuid1 libuv1 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 libxslt1.1 libzip4 procps sudo tar zlib1g
RUN /build/bitnami-user.sh
RUN /build/install-nami.sh
RUN bitnami-pkg unpack php-7.3.22-4 --checksum 0117b9ea5dbd910acaf1e630c6f7517f9b5cedee2dbdd980a12687d2b003927e
RUN bitnami-pkg unpack apache-2.4.46-0 --checksum 93181ed22488a04139fe2ab6d9ca1a81b142392e8c86675b1653a1f28c068fa9
RUN bitnami-pkg install redis-client-6.0.8-0 --checksum 6c5b29d01a98337277c2d74a7bf73996a00feea8bcbcd2fdbaa961aef47de9ce
RUN bitnami-pkg install postgresql-client-11.9.0-0 --checksum 900d01408360012083f63ede35bd477338ec3f18d3e0554635e51f7dccc0fb2d
RUN bitnami-pkg install mysql-client-10.3.24-0 --checksum 94a7e3c58310f59af5c1e14544de0a42bd1ecf394a159db94aacf8ccf6058436
RUN bitnami-pkg install mongodb-client-4.4.1-0 --checksum 9b553a0df5312db187152b0394d729a81e016e255be82eb565393c1705e63e3e
RUN bitnami-pkg install libphp-7.3.22-0 --checksum ac87df7d3775f41c83866359667413c5762bc73e87fae0ceb3e8805de5b7450a
RUN bitnami-pkg install tini-0.19.0-0 --checksum 9a8ae20be31a518f042fcec359f2cf35bfdb4e2a56f2fa8ff9ef2ecaf45da80c
RUN bitnami-pkg install gosu-1.12.0-1 --checksum 51cfb1b7fd7b05b8abd1df0278c698103a9b1a4964bdacd87ca1d5c01631d59c
RUN bitnami-pkg unpack dreamfactory-4.3.1-1 --checksum 60d73d6e2e3e02a9f24e10bd6da539176d599e2cd65a5009e2d2a1174e5a6da4
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN ln -sf /dev/stdout /opt/bitnami/apache/logs/access_log && \
    ln -sf /dev/stderr /opt/bitnami/apache/logs/error_log

COPY rootfs /
ENV APACHE_ENABLE_CUSTOM_PORTS="no" \
    APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="dreamfactory" \
    BITNAMI_IMAGE_VERSION="4.3.1-debian-10-r49" \
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
