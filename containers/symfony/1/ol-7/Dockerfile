FROM bitnami/oraclelinux-extras:7-r445
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib freetds-libs freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline xz-libs zlib
RUN bitnami-pkg unpack php-7.3.9-0 --checksum 4d485c03583bba6b5ff16dba7e3e73024939e3da95f77a0f64b560072053a0d3
RUN bitnami-pkg install mysql-client-10.3.17-0 --checksum 83fd01acb88a54d028a327870cec66bf43f57f326814a16dc4626a5171742229
RUN bitnami-pkg install symfony-1.5.11-20 --checksum d4714f97e462524266a97626854747c743e1d4b5a9f9be155f480eef9b592631

COPY rootfs /
ENV BITNAMI_APP_NAME="symfony" \
    BITNAMI_IMAGE_VERSION="1.5.11-ol-7-r402" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_USER="root" \
    PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:/opt/bitnami/symfony/bin:$PATH" \
    SYMFONY_PROJECT_NAME="myapp"

EXPOSE 8000

WORKDIR /app
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
