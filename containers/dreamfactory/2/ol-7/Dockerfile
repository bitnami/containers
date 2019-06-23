FROM bitnami/oraclelinux-extras:7-r376
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetds freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmcrypt libmemcached libnghttp2 libpng libselinux libssh2 libstdc++ libtasn1 libtidy libuv libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.39-2 --checksum bd13d67036ecb691256893b0ba4034364b90c05747b2afbaa3c097fb218bc2e1
RUN bitnami-pkg install redis-client-5.0.5-0 --checksum a79899fa273686a85e225dbab0278392342237904b638b5ecab6ba79c8d247ee
RUN bitnami-pkg unpack php-7.1.30-0 --checksum 232ee9f323d2ba318e43574670b8e5b327c8f6b9635aebe8b73fb7b8ec2c22f9
RUN bitnami-pkg install mysql-client-10.3.16-0 --checksum bc7ef5b2abef585c0079a7e4cb2a099c5f40cf39402c52078438a39882953ab4
RUN bitnami-pkg install mongodb-client-4.0.10-0 --checksum e6885992f776d05f7ff390674573490602b60e8f7bf4dcd0650a8979298da65b
RUN bitnami-pkg install libphp-7.1.30-0 --checksum 15aa01c485336e8f34f2fba037acecb1af506d7abc23d0942a08c55de339ddf5
RUN bitnami-pkg unpack dreamfactory-2.14.2-0 --checksum 0b7e86d9f059feaab5bbed8afd3cc18536b21166e5fd88721778c2c64841ae39
RUN ln -sf /dev/stdout /opt/bitnami/apache/logs/access_log
RUN ln -sf /dev/stderr /opt/bitnami/apache/logs/error_log

COPY rootfs /
ENV APACHE_HTTPS_PORT_NUMBER="" \
    APACHE_HTTP_PORT_NUMBER="" \
    APACHE_SET_HTTPS_PORT="no" \
    APACHE_SET_HTTP_PORT="no" \
    BITNAMI_APP_NAME="dreamfactory" \
    BITNAMI_IMAGE_VERSION="2.14.2-ol-7-r18" \
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
