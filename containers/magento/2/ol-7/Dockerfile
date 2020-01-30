FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:/opt/bitnami/magento/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages bzip2-libs ca-certificates cronie curl cyrus-sasl-lib expat freetds-libs freetype glibc gmp gnutls gzip hostname keyutils-libs krb5-libs libaio-devel libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libnghttp2 libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs procps-ng readline sqlite sudo tar which xz-libs zlib
RUN /build/bitnami-user.sh && \
    /build/install-nami.sh
RUN bitnami-pkg unpack apache-2.4.41-4 --checksum f776f87e3c54a2ff1e13ed75de39356df465b53ac3264a94c3d6ad9252f5b682
RUN bitnami-pkg unpack php-7.2.27-0 --checksum 1c6dd8382928048eef5898d2e94b3296b41080ce7b9fe70ad74bbd4598c5b2fc
RUN bitnami-pkg unpack mysql-client-10.2.31-0 --checksum 4a6db023e4d0130efd6a31e95d335f5f4114444e5f1ae363acee6bb30c0644c1
RUN bitnami-pkg install libphp-7.2.27-0 --checksum ce26afb558cb054f530cb2023441a8cbb4658945e49d36cb6b82558c9f4f7c39
RUN bitnami-pkg unpack magento-2.3.4-0 --checksum 3570df3cf61e7bbdbd7d289172a61d06f9ee1f3bdd4beb8266f8aafcec730e00
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN /build/install-gosu.sh
RUN find /opt/bitnami/magento/htdocs -type d -print0 | xargs -0 chmod 775 && find /opt/bitnami/magento/htdocs -type f -print0 | xargs -0 chmod 664 && chown -R bitnami:daemon /opt/bitnami/magento/htdocs
RUN /build/install-tini.sh

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="magento" \
    BITNAMI_IMAGE_VERSION="2.3.4-ol-7-r1" \
    ELASTICSEARCH_HOST="" \
    ELASTICSEARCH_PORT_NUMBER="" \
    EXTERNAL_HTTPS_PORT_NUMBER="443" \
    EXTERNAL_HTTP_PORT_NUMBER="80" \
    MAGENTO_ADMINURI="admin" \
    MAGENTO_DATABASE_NAME="bitnami_magento" \
    MAGENTO_DATABASE_PASSWORD="" \
    MAGENTO_DATABASE_USER="bn_magento" \
    MAGENTO_EMAIL="user@example.com" \
    MAGENTO_FIRSTNAME="FirstName" \
    MAGENTO_HOST="127.0.0.1" \
    MAGENTO_LASTNAME="LastName" \
    MAGENTO_MODE="developer" \
    MAGENTO_PASSWORD="bitnami1" \
    MAGENTO_USERNAME="user" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER=""

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
