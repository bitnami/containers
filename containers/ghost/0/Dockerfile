FROM bitnami/minideb-extras:jessie-r13

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=ghost \
    BITNAMI_IMAGE_VERSION=0.11.8-r0 \
    PATH=/opt/bitnami/node/bin:/opt/bitnami/mysql/bin:$PATH

# System packages required
RUN install_packages libc6 zlib1g libssl1.0.0 libncurses5 libtinfo5 libstdc++6 libgcc1 libbz2-1.0 libreadline6 ghostscript imagemagick libmysqlclient18

# Additional modules required
RUN bitnami-pkg install mysql-client-10.1.22-3 --checksum 9e881a7c404f658c93abd665ecd1372f61a591d784e6456c64c0129358a7ff1a
RUN bitnami-pkg install node-4.8.2-0 --checksum 3e5b6898fee0ef9ef59ebecd4eb23fb1b2cc99215d4fdfd49c8c3e6b49bd86e3

# Install ghost
RUN bitnami-pkg unpack ghost-0.11.8-0 --checksum 8a220ca57565dd6a69f50a015f70c9e9d4f76b504310ca13ac80600d33ee1df9

COPY rootfs /

ENV GHOST_PORT="80" \
    GHOST_USERNAME="user" \
    GHOST_PASSWORD="bitnami1" \
    GHOST_EMAIL="user@example.com" \
    BLOG_TITLE="User's Blog" \
    MARIADB_USER="root" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT="3306"

VOLUME ["/bitnami/ghost"]

EXPOSE 2368

ENTRYPOINT ["/app-entrypoint.sh"]

WORKDIR /opt/bitnami/ghost

CMD ["/run.sh"]
