FROM bitnami/oraclelinux-extras:7-r323
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages fontconfig freetype glibc keyutils-libs krb5-libs libcom_err libgcc libselinux libstdc++ ncurses-libs openssl-libs pcre zlib
RUN bitnami-pkg install java-1.8.201-0 --checksum e71b797ceaaf8b0641d1641df129cea10124b058bc24d4ed74738725fabfb8c9
RUN bitnami-pkg unpack tomcat-8.0.53-22 --checksum 307d965a78e5f7f2d931c244a4cbe3f4d7aa3aaeb9e464c10e0249da19290e7b
RUN bitnami-pkg unpack mysql-client-10.1.38-0 --checksum 8140732986832471cc54aede727b66729811a0fa79e6fa86c7c791ce1f513451
RUN bitnami-pkg unpack jasperreports-7.1.1-2 --checksum 69f2959af9b65f20d4a7a5d43d9a30b53591e45f91a56dfbe0fcbdd924fd084b

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="jasperreports" \
    BITNAMI_IMAGE_VERSION="7.1.1-ol-7-r52" \
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

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "tomcat" ]
