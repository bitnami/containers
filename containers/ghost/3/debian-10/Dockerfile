FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX,o+rw" \
    BITNAMI_PKG_EXTRA_DIRS="/.ghost /opt/bitnami/content" \
    HOME="/" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/python/bin:/opt/bitnami/mysql/bin:/opt/bitnami/common/bin:/opt/bitnami/ghost/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl ghostscript gzip imagemagick libaudit1 libbsd0 libbz2-1.0 libc6 libcap-ng0 libffi6 libgcc1 libicu63 libjemalloc2 liblzma5 libncurses6 libncursesw6 libpam0g libreadline7 libsqlite3-0 libssl1.1 libstdc++6 libtinfo6 libx11-6 libxau6 libxcb1 libxdmcp6 libxml2 procps sudo tar zlib1g
RUN /build/bitnami-user.sh
RUN /build/install-nami.sh
RUN bitnami-pkg install node-14.15.4-0 --checksum 1c23a75145fc202950f12bd6cb13a9c9b3ac35a3a09d194c105912d2f4d4a8a6
RUN bitnami-pkg unpack mysql-client-10.3.27-0 --checksum f96905e763a6334b75a7cdb07f8d89658cde02be41cb09d91d0682fc649fdcff
RUN bitnami-pkg install tini-0.19.0-1 --checksum 9b1f1c095944bac88a62c1b63f3bff1bb123aa7ccd371c908c0e5b41cec2528d
RUN bitnami-pkg install gosu-1.12.0-2 --checksum 4d858ac600c38af8de454c27b7f65c0074ec3069880cb16d259a6e40a46bbc50
RUN bitnami-pkg unpack ghost-3.40.5-0 --checksum 43e403d7886e12a723a68533521fcf0209b9a00924dd2c72366ac61399bf0d8d
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="ghost" \
    BITNAMI_IMAGE_VERSION="3.40.5-debian-10-r2" \
    BLOG_TITLE="User's Blog" \
    GHOST_DATABASE_NAME="bitnami_ghost" \
    GHOST_DATABASE_PASSWORD="" \
    GHOST_DATABASE_USER="bn_ghost" \
    GHOST_EMAIL="user@example.com" \
    GHOST_HOST="" \
    GHOST_PASSWORD="bitnami123" \
    GHOST_PORT_NUMBER="80" \
    GHOST_PROTOCOL="http" \
    GHOST_USERNAME="user" \
    LIBNSS_WRAPPER_PATH="/opt/bitnami/common/lib/libnss_wrapper.so" \
    LNAME="ghost" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    MYSQL_CLIENT_ENABLE_SSL="no" \
    MYSQL_CLIENT_SSL_CA_FILE="" \
    NAMI_PREFIX="/.nami" \
    NSS_WRAPPER_GROUP="/opt/bitnami/ghost/nss_group" \
    NSS_WRAPPER_PASSWD="/opt/bitnami/ghost/nss_passwd" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux" \
    SMTP_FROM_ADDRESS="" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_SECURE_CONNECTION="false" \
    SMTP_SERVICE="" \
    SMTP_USER="" \
    USER="ghost"

EXPOSE 2368 3000

WORKDIR /opt/bitnami/ghost
USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
