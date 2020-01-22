FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:/opt/bitnami/symfony/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages bzip2-libs ca-certificates curl cyrus-sasl-lib freetds-libs freetype glibc gmp gnutls gzip hostname keyutils-libs krb5-libs libaio-devel libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs procps-ng readline sudo tar unzip which xz-libs zlib
RUN /build/bitnami-user.sh && \
    /build/install-nami.sh
RUN bitnami-pkg unpack php-7.3.13-3 --checksum 58a34b695011b33ac78f86d2da6117f6110c76c26562a51b9741ca5a03b5b08d
RUN bitnami-pkg install mysql-client-10.3.21-0 --checksum 9e012f0e449a963c923c8ea7a5cc2ab2c688564ed910eaab2aef1ad70c5d8e4b
RUN bitnami-pkg install symfony-1.5.11-21 --checksum 6195f827b5de65ef0363d568236cf21fb4d04af147bd545d347acd8d45e3d784
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN /build/install-gosu.sh
RUN /build/install-tini.sh

COPY rootfs /
ENV BITNAMI_APP_NAME="symfony" \
    BITNAMI_IMAGE_VERSION="1.5.11-ol-7-r554" \
    MARIADB_DATABASE="bitnami_myapp" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_USER="root" \
    SYMFONY_PROJECT_NAME="myapp" \
    SYMFONY_SKIP_DB=""

EXPOSE 8000

WORKDIR /app
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
