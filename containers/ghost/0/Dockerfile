FROM bitnami/minideb-extras:jessie-r17
LABEL maintainer "Bitnami <containers@bitnami.com>"



# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbz2-1.0 libc6 libgcc1 libmysqlclient18 libncurses5 libreadline6 libsqlite3-0 libssl1.0.0 libstdc++6 libtinfo5 zlib1g
RUN bitnami-pkg install node-4.8.3-0 --checksum 82ac604d6b97bd2070c8ff613de802096e5addd644d6817745ca2aa71d689aa3
RUN bitnami-pkg install mysql-client-10.1.24-0 --checksum 3ac33998eefe09a8013036d555f2a8265fc446a707e8d61c63f8621f4a3e5dae
RUN bitnami-pkg unpack ghost-0.11.10-0 --checksum a8861781147c28e450b41ea34b3284dc04fcda79976740726a4d69e51dc82bd7

COPY rootfs /

ENV BITNAMI_APP_NAME="ghost" \
    BITNAMI_IMAGE_VERSION="0.11.10-r0" \
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
    PATH="/opt/bitnami/node/bin:/opt/bitnami/mysql/bin:$PATH" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_SERVICE="" \
    SMTP_USER=""



VOLUME ["/bitnami/ghost"]

EXPOSE 2368

WORKDIR /opt/bitnami/ghost
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
