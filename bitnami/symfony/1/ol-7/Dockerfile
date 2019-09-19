FROM bitnami/oraclelinux-extras:7-r471
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib freetds-libs freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline unzip xz-libs zlib
RUN bitnami-pkg unpack php-7.3.9-1 --checksum d12b49a00eb74dae3b46b4c5b57c9709e79e3157ddd26959c8ca08e919265bb7
RUN bitnami-pkg install mysql-client-10.3.18-1 --checksum d591461ce65ca7c65ebdaf443a4dad68c05e5153cf2d5a9a97b2ff1171dfe42e
RUN bitnami-pkg install symfony-1.5.11-20 --checksum d4714f97e462524266a97626854747c743e1d4b5a9f9be155f480eef9b592631

COPY rootfs /
ENV BITNAMI_APP_NAME="symfony" \
    BITNAMI_IMAGE_VERSION="1.5.11-ol-7-r426" \
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
