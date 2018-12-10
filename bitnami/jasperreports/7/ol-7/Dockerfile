FROM bitnami/oraclelinux-extras:7-r193
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages glib2 glibc keyutils-libs krb5-libs libblkid libcom_err libffi libgcc libmount libselinux libstdc++ libuuid ncurses-libs openssl-libs pcre zlib
RUN bitnami-pkg install java-1.8.191-3 --checksum 47989825b516e8a1ea9f4a8a78e7e4f0a5a8d09515bd75d6fd75f2dd5c00fe3d
RUN bitnami-pkg unpack tomcat-8.0.53-2 --checksum 49f603261b93c5b47580736ef87cc29c306349273bc4b9c96ae5d004d5a25962
RUN bitnami-pkg unpack mysql-client-10.1.37-20 --checksum 916d5a9a191d3a704d9c586a83d8a79348d298e21dff4754feb47a01bf2e5f26
RUN bitnami-pkg unpack jasperreports-7.1.0-20 --checksum 12c93facfc99d78c9b7983b57f056266ebde1e756c39336cc1148e16be5abf46

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="jasperreports" \
    BITNAMI_IMAGE_VERSION="7.1.0-ol-7-r155" \
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
