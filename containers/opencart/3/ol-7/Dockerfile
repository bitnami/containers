FROM bitnami/oraclelinux-extras:7-r494
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetds-libs freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libnghttp2 libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.41-2 --checksum bf50a12c033c1ff0e1cb7696cc1abd29a132cc1c5225e9d2fdbb3c6584e349fe
RUN bitnami-pkg unpack php-7.3.10-3 --checksum b601801a832f7ca051c692bfc5f72a89cac9fb6018afdecac47429b98f3e6943
RUN bitnami-pkg unpack mysql-client-10.3.18-2 --checksum c9d987cf8f6f6831d04920d64598d0c77cf994235753cf4d5d18ac787c12918e
RUN bitnami-pkg install libphp-7.3.10-0 --checksum b9c55b3b223315814d89e903e8a076971e2970edfaa3d74ce0377576f499eacd
RUN bitnami-pkg unpack opencart-3.0.3-2-2 --checksum c16d0c07d338afb76355f647c3b16f5e039aa22d59240f70ef5ba31d077b4d95

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="opencart" \
    BITNAMI_IMAGE_VERSION="3.0.3-2-ol-7-r185" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    OPENCART_DATABASE_NAME="bitnami_opencart" \
    OPENCART_DATABASE_PASSWORD="" \
    OPENCART_DATABASE_USER="bn_opencart" \
    OPENCART_EMAIL="user@example.com" \
    OPENCART_HOST="127.0.0.1" \
    OPENCART_HTTP_TIMEOUT="120" \
    OPENCART_PASSWORD="bitnami1" \
    OPENCART_USERNAME="user" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:$PATH" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_PROTOCOL="" \
    SMTP_USER=""

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "apache" ]
