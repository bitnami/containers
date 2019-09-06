FROM bitnami/oraclelinux-extras:7-r455
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages glibc keyutils-libs krb5-libs libcom_err libgcc libselinux libstdc++ ncurses-libs openssl-libs pcre zlib
RUN bitnami-pkg install java-1.8.222-0 --checksum a90f4ce71ff9b392efdf61e6941117afa31d2d6528bd1a3cad1c6459bcac2b0b
RUN bitnami-pkg unpack tomcat-9.0.24-0 --checksum 4fe1009901b4f436bf7381532076307f17d61ce28b4683fca37e35163d5ddf28
RUN bitnami-pkg unpack mysql-client-10.3.17-0 --checksum 83fd01acb88a54d028a327870cec66bf43f57f326814a16dc4626a5171742229
RUN bitnami-pkg unpack reportserverenterprise-3.0.8-6009-0 --checksum da001cee0dbfdb0f1d7b0d6ae7179670c2458e4e16cce2ba77f5d9741e883a5a

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="reportserverenterprise" \
    BITNAMI_IMAGE_VERSION="3.0.8-6009-ol-7-r11" \
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
