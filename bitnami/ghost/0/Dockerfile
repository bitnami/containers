FROM bitnami/minideb-extras:jessie-r14
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME="ghost" \
    BITNAMI_IMAGE_VERSION="0.11.8-r1" \
    BLOG_TITLE="User's Blog" \
    GHOST_EMAIL="user@example.com" \
    GHOST_HOST="" \
    GHOST_PASSWORD="bitnami1" \
    GHOST_PORT="80" \
    GHOST_USERNAME="user" \
    MARIADB_HOST="mariadb" \
    MARIADB_PASSWORD="" \
    MARIADB_PORT="3306" \
    MARIADB_USER="root" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/mysql/bin:$PATH" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_SERVICE="" \
    SMTP_USER=""

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbz2-1.0 libc6 libgcc1 libmysqlclient18 libncurses5 libreadline6 libssl1.0.0 libstdc++6 libtinfo5 zlib1g
RUN bitnami-pkg install node-4.8.2-0 --checksum 3e5b6898fee0ef9ef59ebecd4eb23fb1b2cc99215d4fdfd49c8c3e6b49bd86e3
RUN bitnami-pkg install mysql-client-10.1.22-3 --checksum 9e881a7c404f658c93abd665ecd1372f61a591d784e6456c64c0129358a7ff1a
RUN bitnami-pkg unpack ghost-0.11.8-0 --checksum 8a220ca57565dd6a69f50a015f70c9e9d4f76b504310ca13ac80600d33ee1df9

COPY rootfs /

VOLUME ["/bitnami/ghost"]

EXPOSE 2368

WORKDIR /opt/bitnami/ghost
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
