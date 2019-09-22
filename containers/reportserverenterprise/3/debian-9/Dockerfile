FROM bitnami/minideb-extras:stretch-r484
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libc6 libgcc1 libncurses5 libssl1.0.2 libstdc++6 libtinfo5 zlib1g
RUN bitnami-pkg install java-1.8.222-1 --checksum 373c9f3d2943b9ff653fc0e7c69b1d54a75807726691a09190648808500b8253
RUN bitnami-pkg unpack tomcat-9.0.24-0 --checksum 6658e3362af87b86d8f1c6af56b26385938fc979017eb8612119fe468acedb77
RUN bitnami-pkg unpack mysql-client-10.3.18-2 --checksum 9ba76d9543cc87642f23cc4987e12750e8690d45274c3701aa429ef19e3b8e08
RUN bitnami-pkg unpack reportserverenterprise-3.0.8-6009-1 --checksum df11cf8e30feaa710bd05281cd9cbfc5a4b6a7c58136d6a5b71fe25043f3e018

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="reportserverenterprise" \
    BITNAMI_IMAGE_VERSION="3.0.8-6009-debian-9-r21" \
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
