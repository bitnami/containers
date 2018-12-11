FROM bitnami/oraclelinux-extras:7-r194
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX,o+rw" \
    BITNAMI_PKG_EXTRA_DIRS="/.ghost /opt/bitnami/content" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages bzip2-libs glibc keyutils-libs krb5-libs libcom_err libgcc libselinux libstdc++ ncurses-libs nss-softokn-freebl openssl-libs pcre readline sqlite zlib
RUN bitnami-pkg install node-8.14.0-20 --checksum 09f2e1fdde74203e56352e494d55644f227dc71399c9f45f412b415a40a1b8b1
RUN bitnami-pkg unpack mysql-client-10.1.37-20 --checksum 916d5a9a191d3a704d9c586a83d8a79348d298e21dff4754feb47a01bf2e5f26
RUN bitnami-pkg unpack ghost-2.4.0-20 --checksum 9571582ffedfe184cd54018ac59aac44ee0aa6ceb36d1cd4f225948bf295049b

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="ghost" \
    BITNAMI_IMAGE_VERSION="2.4.0-ol-7-r37" \
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
