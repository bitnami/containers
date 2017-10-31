FROM bitnami/minideb-extras:jessie-r22
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    BITNAMI_PKG_EXTRA_DIRS="/.ghost /.config /.cache" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbz2-1.0 libc6 libgcc1 libmysqlclient18 libncurses5 libreadline6 libsqlite3-0 libssl1.0.0 libstdc++6 libtinfo5 zlib1g
RUN bitnami-pkg install node-6.11.5-0 --checksum 689f699e6828854c74a632359d4a2ca7bf59b7d0dd5218a4b20596581a163ac0
RUN bitnami-pkg install mysql-client-10.1.28-0 --checksum 8a0ccfd6a62ffccdb25fcf39754c2526b120f416dd390194e8d6edd2ec8ddcee
RUN bitnami-pkg unpack ghost-1.16.1-0 --checksum 014b7ac77b1dbb175d14cad42bbe772bd5f2c2bd8246c9e28776d6f6d838a365

COPY rootfs /

ENV BITNAMI_APP_NAME="ghost" \
    BITNAMI_IMAGE_VERSION="1.16.1-r0" \
    BLOG_TITLE="User's Blog" \
    GHOST_EMAIL="user@example.com" \
    GHOST_HOST="" \
    GHOST_PASSWORD="bitnami123" \
    GHOST_PORT_NUMBER="" \
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
