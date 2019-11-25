FROM bitnami/oraclelinux-extras:7-r544
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib freetds-libs freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline unzip xz-libs zlib
RUN bitnami-pkg unpack php-7.3.12-0 --checksum d826f6f7b9e774271d3f9056e7710e1691f09cff4f3bb27f84b2d5ec6e223bb9
RUN bitnami-pkg install mysql-client-10.3.20-0 --checksum 6e895c7c56273bf724d87014c70187045fa0a399d9f24067e84f27475e3c071a
RUN bitnami-pkg install symfony-1.5.11-21 --checksum 6195f827b5de65ef0363d568236cf21fb4d04af147bd545d347acd8d45e3d784

COPY rootfs /
ENV BITNAMI_APP_NAME="symfony" \
    BITNAMI_IMAGE_VERSION="1.5.11-ol-7-r498" \
    MARIADB_DATABASE="bitnami_myapp" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_USER="root" \
    PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:/opt/bitnami/symfony/bin:$PATH" \
    SYMFONY_PROJECT_NAME="myapp" \
    SYMFONY_SKIP_DB=""

EXPOSE 8000

WORKDIR /app
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
