FROM bitnami/oraclelinux-extras:7-r327
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages bzip2-libs cyrus-sasl-lib freetds freetype glibc gmp gnutls keyutils-libs krb5-libs libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmcrypt libmemcached libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs readline xz-libs zlib
RUN bitnami-pkg install php-7.1.29-0 --checksum 5a0aefb353b003d4d0cd83601c5c8d20e552ddee27ca8a7b54fe66117a6335bd
RUN bitnami-pkg install mysql-client-10.1.39-0 --checksum 7ac7efb8400917e5ac49a8a5ea22cac62f079870cda71fa432303f2303f7e533
RUN bitnami-pkg install symfony-1.5.11-20 --checksum d4714f97e462524266a97626854747c743e1d4b5a9f9be155f480eef9b592631

COPY rootfs /
ENV BITNAMI_APP_NAME="symfony" \
    BITNAMI_IMAGE_VERSION="1.5.11-ol-7-r283" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_USER="root" \
    PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:/opt/bitnami/symfony/bin:$PATH" \
    SYMFONY_PROJECT_NAME="myapp"

EXPOSE 8000

WORKDIR /app
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
