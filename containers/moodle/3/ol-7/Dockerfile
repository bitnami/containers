FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/mysql/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages bzip2-libs ca-certificates cronie curl cyrus-sasl-lib expat freetds-libs freetype glibc gmp gnutls gzip hostname keyutils-libs krb5-libs libaio-devel libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libnghttp2 libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs procps-ng readline sqlite sudo tar which xz-libs zlib
RUN /bitnami-user.sh && \
    /install-nami.sh
RUN bitnami-pkg unpack apache-2.4.41-4 --checksum f776f87e3c54a2ff1e13ed75de39356df465b53ac3264a94c3d6ad9252f5b682
RUN bitnami-pkg unpack php-7.3.13-1 --checksum a2bb2a5ddd668c0662a12704747c5a6843f2ba05d03fb03f1e95140c33e14ffc
RUN bitnami-pkg unpack mysql-client-10.1.43-0 --checksum eb30f14e1bc364fea5fc47b0d17d4a1cb506b89339c4e88b0f9f0c879dd99434
RUN bitnami-pkg install libphp-7.3.13-2 --checksum ddba3fba1c2c84d24cbe3545222644d6c5ccc0a3e2340b03ad28c09d0f0d0c53
RUN bitnami-pkg unpack moodle-3.8.1-0 --checksum afecbfe04f7f0b929d7ace5db8e0bd590992583ad241d9bf5fde8b4738534265
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN curl --silent -L https://github.com/tianon/gosu/releases/download/1.11/gosu-amd64 > /usr/local/bin/gosu && \
    echo 0b843df6d86e270c5b0f5cbd3c326a04e18f4b7f9b8457fa497b0454c4b138d7 /usr/local/bin/gosu | sha256sum --check && \
    chmod u+x /usr/local/bin/gosu && \
    mkdir -p /opt/bitnami/licenses && \
    curl --silent -L https://raw.githubusercontent.com/tianon/gosu/master/LICENSE > /opt/bitnami/licenses/gosu-1.11.txt
RUN for server in "ha.pool.sks-keyservers.net" "hkp://p80.pool.sks-keyservers.net:80" "keyserver.ubuntu.com" "hkp://keyserver.ubuntu.com:80" "pgp.mit.edu"; do gpg --keyserver $server --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 && break || : ; done && \
    gpg --fingerprint 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 | grep -q "6380 DC42 8747 F6C3 93FE  ACA5 9A84 159D 7001 A4E5" && \
    curl --silent -L https://github.com/krallin/tini/releases/download/v0.13.2/tini.asc > /tmp/tini.asc && \
    curl --silent -L https://github.com/krallin/tini/releases/download/v0.13.2/tini > /usr/local/bin/tini && \
    gpg --verify /tmp/tini.asc /usr/local/bin/tini && \
    chmod +x /usr/local/bin/tini && \
    mkdir -p /opt/bitnami/licenses && \
    curl --silent -L https://raw.githubusercontent.com/krallin/tini/master/LICENSE > /opt/bitnami/licenses/tini-0.13.2.txt

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="moodle" \
    BITNAMI_IMAGE_VERSION="3.8.1-ol-7-r6" \
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
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_PROTOCOL="" \
    SMTP_USER=""

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
