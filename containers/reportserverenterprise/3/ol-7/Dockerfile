FROM bitnami/oraclelinux-extras:7-r537
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages fontconfig glibc keyutils-libs krb5-libs libcom_err libgcc libselinux libstdc++ ncurses-libs openssl-libs pcre zlib
RUN bitnami-pkg install java-1.8.232-0 --checksum fbac74363c807fce14538c5f9a9232602adc7883c1c5936571c741625de2479e
RUN bitnami-pkg unpack tomcat-9.0.27-0 --checksum 488a8fcddcd600ae8c9f32bb55ed4cf6f25d35d1e960b1aecc2b6391b6a30319
RUN bitnami-pkg unpack mysql-client-10.3.20-0 --checksum 6e895c7c56273bf724d87014c70187045fa0a399d9f24067e84f27475e3c071a
RUN bitnami-pkg unpack reportserverenterprise-3.1.0-6015-0 --checksum 7bad5ce10b47f380e4620086a8e61e16897ca4155897da7326d9425f4a1c63fe

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="reportserverenterprise" \
    BITNAMI_IMAGE_VERSION="3.1.0-6015-ol-7-r35" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/tomcat/bin:/opt/bitnami/mysql/bin:$PATH" \
    REPORTSERVER_CRYPTPASSPHRASE="" \
    REPORTSERVER_CRYPTSALT="" \
    REPORTSERVER_DATABASE_NAME="bitnami_reportserver" \
    REPORTSERVER_DATABASE_PASSWORD="" \
    REPORTSERVER_DATABASE_USER="bn_reportserver" \
    REPORTSERVER_EMAIL="user@example.com" \
    REPORTSERVER_INSTALLDEMODATA="" \
    REPORTSERVER_PASSWORD="bitnami" \
    REPORTSERVER_USERNAME="user" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_SSL_ENABLE="false" \
    SMTP_TLS_ENABLE="false" \
    SMTP_TLS_REQUIRED="false" \
    SMTP_USER=""

EXPOSE 8080 8443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "tomcat" ]
