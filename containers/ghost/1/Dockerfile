FROM bitnami/minideb-extras:jessie-r22
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    BITNAMI_PKG_EXTRA_DIRS="/.ghost /.config /.cache" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbz2-1.0 libc6 libgcc1 libmysqlclient18 libncurses5 libreadline6 libsqlite3-0 libssl1.0.0 libstdc++6 libtinfo5 zlib1g
RUN bitnami-pkg install node-6.11.3-0 --checksum 44d840c83cd9b3a09ecef5238b261372441d1803cf73b6c5ac5689a96d33db8b
RUN bitnami-pkg install mysql-client-10.1.26-0 --checksum 731e07b76a06c8b7f2a0b79d528f2f1f37e49142f682ab27ab8f4edfc9176d83
RUN bitnami-pkg unpack ghost-1.9.0-0 --checksum 1d7bf44f2409bbf56127560ad3237e9cb1f7971821efc79ca1196db8c8e4ac2c

COPY rootfs /

ENV BITNAMI_APP_NAME="ghost" \
    BITNAMI_IMAGE_VERSION="1.9.0-r0" \
    BLOG_TITLE="User's Blog" \
    GHOST_EMAIL="user@example.com" \
    GHOST_HOST="" \
    GHOST_PASSWORD="bitnami1" \
    GHOST_PORT_NUMBER="80" \
    GHOST_USERNAME="user" \
    MARIADB_HOST="mariadb" \
    MARIADB_PASSWORD="" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_USER="root" \
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
