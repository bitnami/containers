FROM bitnami/minideb-extras:jessie-r52
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX,o+rw" \
    BITNAMI_PKG_EXTRA_DIRS="/.ghost /.config /.cache /opt/bitnami/content" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbz2-1.0 libc6 libgcc1 libmysqlclient18 libncurses5 libreadline6 libsqlite3-0 libssl1.0.0 libstdc++6 libtinfo5 zlib1g
RUN bitnami-pkg install node-8.11.1-0 --checksum 80a803bba171a7be8beb5e1bca0ea7977e21bfda3c54e5db8236d1861be021e3
RUN bitnami-pkg unpack mysql-client-10.1.33-0 --checksum 1b1608f1c1f4e21f05037225e095c49035ad8bfdb8b580abbb904c9f2448a5c6
RUN bitnami-pkg unpack ghost-1.22.7-0 --checksum 9381d085812e1f3f7524004e40ea230d7d8cce0bb50c4c6650dff31cbc9f3972

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="ghost" \
    BITNAMI_IMAGE_VERSION="1.22.7-r4" \
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
    PATH="/opt/bitnami/node/bin:/opt/bitnami/mysql/bin:/opt/bitnami/ghost/bin:$PATH" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_SERVICE="" \
    SMTP_USER=""

EXPOSE 2368

WORKDIR /opt/bitnami/ghost
USER 1001
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
