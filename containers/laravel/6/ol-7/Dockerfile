FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/node/bin:/opt/bitnami/laravel/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages bzip2-libs ca-certificates curl cyrus-sasl-lib freetds-libs freetype glibc gmp gnutls gzip hostname keyutils-libs krb5-libs libaio-devel libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs procps-ng readline sqlite sudo tar which xz-libs zlib
RUN /bitnami-user.sh && \
    /install-nami.sh
RUN bitnami-pkg unpack php-7.3.13-1 --checksum a2bb2a5ddd668c0662a12704747c5a6843f2ba05d03fb03f1e95140c33e14ffc
RUN bitnami-pkg install node-8.17.0-0 --checksum c6720534f7fa5167debe21fb272168c98ef912b1b8c57eb50a21669b6ca16192
RUN bitnami-pkg install laravel-6.8.0-0 --checksum a91f100d935d4d37c2dab544266d4cc74d6e62ce4efe8ded95296197d8f81f9f
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN mkdir /app && chown bitnami:bitnami /app
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
ENV BITNAMI_APP_NAME="laravel" \
    BITNAMI_IMAGE_VERSION="6.8.0-ol-7-r29" \
    NODE_PATH="/opt/bitnami/node/lib/node_modules"

EXPOSE 3000

WORKDIR /app
USER bitnami
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "php", "artisan", "serve", "--host=0.0.0.0", "--port=3000" ]
