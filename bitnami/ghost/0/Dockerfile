FROM gcr.io/stacksmith-images/minideb:jessie-r10

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=ghost \
    BITNAMI_IMAGE_VERSION=0.11.5-r0 \
    PATH=/opt/bitnami/node/bin:/opt/bitnami/mysql/bin:$PATH

# System packages required
RUN install_packages libc6 zlib1g libssl1.0.0 libncurses5 libtinfo5 libstdc++6 libgcc1 libbz2-1.0 libreadline6 ghostscript imagemagick libmysqlclient18

# Additional modules required
RUN bitnami-pkg install mysql-client-10.1.21-1 --checksum 63155b08efa834316c47f29200a667f6d52506063dae861eb1edfba4266a9d62
RUN bitnami-pkg install node-4.8.0-0 --checksum 800e972fbdf1b0a5afc845990bb981359dee4f9ad31ae4115a18ababa6c66508

# Install ghost
RUN bitnami-pkg unpack ghost-0.11.5-0 --checksum 8e70e4762aa464af8abf3c255c398f8cff5c9703645d48fe4f00cacad2d7a10a

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

CMD ["nami", "start", "--foreground", "ghost"]
