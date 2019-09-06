FROM bitnami/oraclelinux-extras:7-r458
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cronie cyrus-sasl-lib expat freetds-libs freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libnghttp2 libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.41-1 --checksum 64b7880c3d0f0f9e7cde0e71496eed06d4240a90a2b6d62c2443fce54c614691
RUN bitnami-pkg unpack php-7.3.9-1 --checksum d12b49a00eb74dae3b46b4c5b57c9709e79e3157ddd26959c8ca08e919265bb7
RUN bitnami-pkg unpack mysql-client-10.1.41-0 --checksum 0da921868a72b59000042c371ab0bb492636266fe668dd1c26cabd7e4d01f92b
RUN bitnami-pkg install libphp-7.3.9-0 --checksum d571181cffcf99e28bf1a53f5664136b391f99996f1471ab426aa73e6f09eed2
RUN bitnami-pkg unpack moodle-3.7.2-0 --checksum f869aff58f40e116dba3777d0c5224e78d0867ab1b743cc731c4042c705730c7
RUN ln -sf /dev/stdout /opt/bitnami/apache/logs/access_log
RUN ln -sf /dev/stderr /opt/bitnami/apache/logs/error_log

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    APACHE_HTTPS_PORT_NUMBER="" \
    APACHE_HTTP_PORT_NUMBER="" \
    APACHE_SET_HTTPS_PORT="no" \
    APACHE_SET_HTTP_PORT="no" \
    BITNAMI_APP_NAME="moodle" \
    BITNAMI_IMAGE_VERSION="3.7.2-ol-7-r0" \
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
    MOODLE_SKIP_INSTALL="no" \
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
