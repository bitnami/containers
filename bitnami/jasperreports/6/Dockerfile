FROM bitnami/minideb-extras:jessie-r38
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libc6 libgcc1 libncurses5 libssl1.0.0 libstdc++6 libtinfo5 zlib1g
RUN bitnami-pkg install java-1.8.171-0 --checksum c5ea6aa978992a3606b070b3ef4287b0b8118611f015281868f4466a81c299b1
RUN bitnami-pkg unpack tomcat-8.0.51-0 --checksum 53d4e40acbdaf7637f9fdb31fa013ec7397ff2a892fcf51bc0f7224f5ac530a3
RUN bitnami-pkg unpack mysql-client-10.1.32-0 --checksum e65dc7fa2dd7fa6cac74d62a2cff2e3d40f650e721ac955381dc7b6f83d4a141
RUN bitnami-pkg unpack jasperreports-6.4.3-0 --checksum 29c3b9c936d5f4714196b74baea712fee6e5f7404c7ebeca985f43d29ace6dd2

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="jasperreports" \
    BITNAMI_IMAGE_VERSION="6.4.3-r12" \
    JASPERREPORTS_DATABASE_NAME="bitnami_jasperreports" \
    JASPERREPORTS_DATABASE_PASSWORD="" \
    JASPERREPORTS_DATABASE_USER="bn_jasperreports" \
    JASPERREPORTS_EMAIL="user@example.com" \
    JASPERREPORTS_PASSWORD="bitnami" \
    JASPERREPORTS_USERNAME="user" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/tomcat/bin:/opt/bitnami/mysql/bin:$PATH" \
    SMTP_EMAIL="" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_PROTOCOL="" \
    SMTP_USER="" \
    TOMCAT_AJP_PORT_NUMBER="8009" \
    TOMCAT_ALLOW_REMOTE_MANAGEMENT="0" \
    TOMCAT_HTTP_PORT_NUMBER="8080" \
    TOMCAT_PASSWORD="" \
    TOMCAT_SHUTDOWN_PORT_NUMBER="8005" \
    TOMCAT_USERNAME="user"

EXPOSE 8080 8443

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","tomcat"]
