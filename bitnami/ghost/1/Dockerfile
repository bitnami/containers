FROM bitnami/minideb-extras:jessie-r97
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX,o+rw" \
    BITNAMI_PKG_EXTRA_DIRS="/.ghost /.config /.cache /opt/bitnami/content" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbz2-1.0 libc6 libgcc1 libmysqlclient18 libncurses5 libreadline6 libsqlite3-0 libssl1.0.0 libstdc++6 libtinfo5 zlib1g
RUN bitnami-pkg install node-8.11.3-0 --checksum e8a276dcff0eb7c501f7c8ba7bd3df532886faf31701fa83c4ab0d7614b4bef2
RUN bitnami-pkg unpack mysql-client-10.1.34-0 --checksum 2954d9390cb8b91dc924beacc179ed03050f6c5cb7ad328010cdbde1ab05c1e9
RUN bitnami-pkg unpack ghost-1.24.7-0 --checksum a7eb1ecad1f7b69ed1f6ef19e4b3b66990e7004b48da4524798cd76c44ebf247

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="ghost" \
    BITNAMI_IMAGE_VERSION="1.24.7-debian-8-r2" \
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
