FROM bitnami/minideb-extras:stretch-r227
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX,o+rw" \
    BITNAMI_PKG_EXTRA_DIRS="/.ghost /opt/bitnami/content" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbz2-1.0 libc6 libgcc1 libncurses5 libreadline7 libsqlite3-0 libssl1.0.2 libssl1.1 libstdc++6 libtinfo5 zlib1g
RUN bitnami-pkg install node-8.14.1-0 --checksum 3ad59ddee88c0f80a8508775b73997507063007395b300cd066d54ecfead2a48
RUN bitnami-pkg unpack mysql-client-10.1.37-20 --checksum 414e98c1024187f1f0300eb3571f3d5ae54cdb36f3f08430be634714700bd1d9
RUN bitnami-pkg unpack ghost-2.9.0-0 --checksum 909bb64a02dc9820deb4c22953b446fddcf878b70dab0900462c9822a5a7aaa2

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="ghost" \
    BITNAMI_IMAGE_VERSION="2.9.0-debian-9-r3" \
    BLOG_TITLE="User's Blog" \
    GHOST_DATABASE_NAME="bitnami_ghost" \
    GHOST_DATABASE_PASSWORD="" \
    GHOST_DATABASE_USER="bn_ghost" \
    GHOST_EMAIL="user@example.com" \
    GHOST_HOST="" \
    GHOST_PASSWORD="bitnami123" \
    GHOST_PORT_NUMBER="" \
    GHOST_USERNAME="user" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/mysql/bin:/opt/bitnami/ghost/bin:$PATH" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_SERVICE="" \
    SMTP_USER=""

EXPOSE 2368

WORKDIR /opt/bitnami/ghost
USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
