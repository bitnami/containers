FROM bitnami/oraclelinux-extras:7-r572
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib expat freetds-libs freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libnghttp2 libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline sqlite xz-libs zlib
RUN bitnami-pkg unpack apache-2.4.41-3 --checksum 30ae9f98466bc180ec5b3121b000e0a8ee36ee3434d4645c7c3aa22710cc6166
RUN bitnami-pkg unpack php-7.2.26-0 --checksum 8a6d5adeb4cbb51b17809ccd57c005ff2148a4c4086d99ace2bd938646874d07
RUN bitnami-pkg unpack mysql-client-10.2.30-0 --checksum e05168d0d2ce16b2909860720b0dea096b4ae6b0e3afd9721f78948f0bb46593
RUN bitnami-pkg install libphp-7.2.26-1 --checksum 281ffbacd688a30cd2a902b8edc890d14141f53a9fc5a0dc9560780558baaa12
RUN bitnami-pkg unpack orangehrm-4.3.4-0-0 --checksum 0ec8ae50d2060d6464eb402b81ce0aae00f55e5e29354f0c81f896ea6885ad94

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="orangehrm" \
    BITNAMI_IMAGE_VERSION="4.3.4-0-ol-7-r53" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    ORANGEHRM_DATABASE_NAME="bitnami_orangehrm" \
    ORANGEHRM_DATABASE_PASSWORD="" \
    ORANGEHRM_DATABASE_USER="bn_orangehrm" \
    ORANGEHRM_PASSWORD="Bitnami.12345" \
    ORANGEHRM_USERNAME="admin" \
    PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:$PATH" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_PROTOCOL="none" \
    SMTP_USER=""

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "apache" ]
