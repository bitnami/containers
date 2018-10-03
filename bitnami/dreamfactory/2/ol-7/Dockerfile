FROM bitnami/oraclelinux-extras:7-r125
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetds freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmcrypt libpcap libpng libselinux libssh2 libstdc++ libtasn1 libtidy libuv libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.35-0 --checksum 5d3d1836c2ff00e299779b9f5ad90f65e599655b6a96908c579966d206bb4396
RUN bitnami-pkg install redis-client-4.0.11-0 --checksum b584dc1dc7d52e44dd40400248e4ba33ff805550510af8774a615d4c1aefaabc
RUN bitnami-pkg unpack php-7.1.22-1 --checksum d454d26b6288af034ee7af734bd3775f591c70345772c9b1c731c44ab60c5be7
RUN bitnami-pkg install mysql-client-10.1.36-0 --checksum 066d5ea1a684175a9a9709a0d7d1585067324f58bcd8a569d1fd8e61028dc71b
RUN bitnami-pkg install mongodb-client-3.6.5-0 --checksum e398c24d43e81d7e555b473a32bc045dd9bdfd7a797e5936b7e54b83d239be52
RUN bitnami-pkg install libphp-7.1.22-1 --checksum 42018a53bcaf3217a061e58c9db5a2f31c8b92ee646fd7cf9ce0b78c421d2091
RUN bitnami-pkg unpack dreamfactory-2.14.1-0 --checksum 0f26d28c29c354356dc9d4bd7bf2b874075abb8b7d209f383b850674b768fdfb

COPY rootfs /
ENV APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    BITNAMI_APP_NAME="dreamfactory" \
    BITNAMI_IMAGE_VERSION="2.14.1-ol-7-r1" \
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
