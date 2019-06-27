FROM bitnami/oraclelinux-extras:7-r380
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cronie cyrus-sasl-lib expat freetds freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmcrypt libmemcached libnghttp2 libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.39-2 --checksum bd13d67036ecb691256893b0ba4034364b90c05747b2afbaa3c097fb218bc2e1
RUN bitnami-pkg unpack php-7.1.30-0 --checksum 232ee9f323d2ba318e43574670b8e5b327c8f6b9635aebe8b73fb7b8ec2c22f9
RUN bitnami-pkg unpack mysql-client-10.1.40-0 --checksum 42463db101d01a34a666677e4126b53f3a579b2cda7f698ac3100c6c40ce6c18
RUN bitnami-pkg install libphp-7.1.30-0 --checksum 15aa01c485336e8f34f2fba037acecb1af506d7abc23d0942a08c55de339ddf5
RUN bitnami-pkg unpack moodle-3.7.0-1 --checksum 7f846fda0bc576a89db52867a8294014b2503ad367b9d94595d4c3a746848eb3
RUN ln -sf /dev/stdout /opt/bitnami/apache/logs/access_log
RUN ln -sf /dev/stderr /opt/bitnami/apache/logs/error_log

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    APACHE_HTTPS_PORT_NUMBER="" \
    APACHE_HTTP_PORT_NUMBER="" \
    APACHE_SET_HTTPS_PORT="no" \
    APACHE_SET_HTTP_PORT="no" \
    BITNAMI_APP_NAME="moodle" \
    BITNAMI_IMAGE_VERSION="3.7.0-ol-7-r42" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MOODLE_DATABASE_NAME="bitnami_moodle" \
    MOODLE_DATABASE_PASSWORD="" \
    MOODLE_DATABASE_USER="bn_moodle" \
    MOODLE_EMAIL="user@example.com" \
    MOODLE_LANGUAGE="en" \
    MOODLE_PASSWORD="bitnami" \
    MOODLE_SITENAME="New Site" \
    MOODLE_USERNAME="user" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:$PATH" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_PROTOCOL="" \
    SMTP_USER=""

VOLUME [ "/certs" ]

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
