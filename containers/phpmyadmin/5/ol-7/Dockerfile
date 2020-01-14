FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV PATH="/opt/bitnami/apache/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages bzip2-libs ca-certificates curl cyrus-sasl-lib expat freetds-libs freetype glibc gmp gnutls gzip hostname keyutils-libs krb5-libs libaio-devel libcom_err libcurl libffi libgcc libgcrypt libgpg-error libicu libidn libjpeg-turbo libmemcached libnghttp2 libpng libselinux libssh2 libstdc++ libtasn1 libtidy libxml2 libxslt ncurses-libs nettle nspr nss nss-softokn-freebl nss-util openldap openssl-libs p11-kit pcre postgresql-libs procps-ng readline sqlite sudo tar which xz-libs zlib
RUN curl --silent -L https://nami-prod.s3.amazonaws.com/tools/nami/releases/nami-1.0.0-1-linux-x64.tar.gz > /tmp/nami-linux-x64.tar.gz && \
    echo "80488279b056d5e9c183fe34097c5f496715ab16a602afcc9f78d59f15139a16 /tmp/nami-linux-x64.tar.gz" | sha256sum --check && \
    mkdir -p /opt/bitnami/nami /opt/bitnami/licenses && \
    tar xzf /tmp/nami-linux-x64.tar.gz --strip 1 -C /opt/bitnami/nami && \
    rm /tmp/nami-linux-x64.tar.gz && \
    curl --silent -L https://raw.githubusercontent.com/bitnami/nami/master/COPYING > /opt/bitnami/licenses/nami-1.0.0-1.txt
RUN bitnami-pkg unpack apache-2.4.41-4 --checksum f776f87e3c54a2ff1e13ed75de39356df465b53ac3264a94c3d6ad9252f5b682
RUN bitnami-pkg unpack php-7.3.13-1 --checksum a2bb2a5ddd668c0662a12704747c5a6843f2ba05d03fb03f1e95140c33e14ffc
RUN bitnami-pkg install libphp-7.3.13-2 --checksum ddba3fba1c2c84d24cbe3545222644d6c5ccc0a3e2340b03ad28c09d0f0d0c53
RUN bitnami-pkg unpack phpmyadmin-5.0.1-0 --checksum f2c268bc409824d90f62225496febb2a850354aaaeda74daca9f07f1050b84d1
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN useradd -ms /bin/bash bitnami && \
    mkdir -p /opt/bitnami && chown bitnami:bitnami /opt/bitnami && \
    sed -i -e 's/\s*Defaults\s*secure_path\s*=/# Defaults secure_path=/' /etc/sudoers && \
    echo 'bitnami ALL=NOPASSWD: ALL' >> /etc/sudoers
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
ENV BITNAMI_APP_NAME="phpmyadmin" \
    BITNAMI_IMAGE_VERSION="5.0.1-ol-7-r1" \
    DATABASE_ENABLE_SSL="no" \
    DATABASE_HOST="mariadb" \
    DATABASE_PORT_NUMBER="3306" \
    DATABASE_SSL_CA="" \
    DATABASE_SSL_CA_PATH="" \
    DATABASE_SSL_CERT="" \
    DATABASE_SSL_CIPHERS="" \
    DATABASE_SSL_KEY="" \
    DATABASE_SSL_VERIFY="yes" \
    PHPMYADMIN_ALLOW_ARBITRARY_SERVER="" \
    PHPMYADMIN_ALLOW_NO_PASSWORD="true" \
    REQUIRE_LOCAL="no"

EXPOSE 80 443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "apache" ]
