FROM bitnami/minideb-extras:jessie-r13

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=ghost \
    BITNAMI_IMAGE_VERSION=0.11.7-r1 \
    PATH=/opt/bitnami/node/bin:/opt/bitnami/mysql/bin:$PATH

# System packages required
RUN install_packages libc6 zlib1g libssl1.0.0 libncurses5 libtinfo5 libstdc++6 libgcc1 libbz2-1.0 libreadline6 ghostscript imagemagick libmysqlclient18

# Additional modules required
RUN bitnami-pkg install mysql-client-10.1.21-2 --checksum f5d875d00ff198eea981ffa6d02d3135659baf48cbfc418604f1b75fb5a31e63
RUN bitnami-pkg install node-4.8.0-0 --checksum 800e972fbdf1b0a5afc845990bb981359dee4f9ad31ae4115a18ababa6c66508

# Install ghost
RUN bitnami-pkg unpack ghost-0.11.7-0 --checksum 376198b6e86229a890fe6706f80406e6a99246f6a77fe7ff3f04a9ffd09034a3

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

CMD ["/opt/bitnami/node/bin/node", "/opt/bitnami/ghost/index.js"]
