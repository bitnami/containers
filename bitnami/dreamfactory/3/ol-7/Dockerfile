FROM bitnami/oraclelinux-extras:7-r479
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetds-libs freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmcrypt libmemcached libnghttp2 libpng libselinux libssh2 libstdc++ libtasn1 libtidy libuv libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.41-2 --checksum bf50a12c033c1ff0e1cb7696cc1abd29a132cc1c5225e9d2fdbb3c6584e349fe
RUN bitnami-pkg install redis-client-5.0.5-1 --checksum f97c537a52a8566d0968d0418ef52f1a97f9fe205ed4ce06cc7daca8b094813c
RUN bitnami-pkg unpack php-7.1.32-4 --checksum 4cd012c44b77944279c95428a34fa65199f8ada0a8c2f6d0e14280d368c08629
RUN bitnami-pkg install mysql-client-10.3.18-2 --checksum c9d987cf8f6f6831d04920d64598d0c77cf994235753cf4d5d18ac787c12918e
RUN bitnami-pkg install mongodb-client-4.0.12-1 --checksum 6f1ed4f3a15c99cd8ea98f5a393fefdeb7809e989d01539ed9b5f6e881aa7b85
RUN bitnami-pkg install libphp-7.1.32-1 --checksum b316c26f169f10dc05299a346bc65602c2934d0d8670d9157a57d1b16c804947
RUN bitnami-pkg unpack dreamfactory-3.0.1-0 --checksum 4adfec9855b36206a047c8436eed1899027f15231944471582cb9172cc5dc8a1

COPY rootfs /
ENV BITNAMI_APP_NAME="dreamfactory" \
    BITNAMI_IMAGE_VERSION="3.0.1-ol-7-r40" \
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
CMD [ "nami", "start", "--foreground", "apache" ]
