FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV PATH="/opt/bitnami/java/bin:/opt/bitnami/tomcat/bin:/opt/bitnami/mysql/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl dirmngr fontconfig fonts-dejavu-extra gnupg libaudit1 libc6 libcap-ng0 libgcc1 libjemalloc2 libncurses6 libpam0g libssl1.1 libstdc++6 libtinfo6 procps sudo unzip zlib1g
RUN /build/bitnami-user.sh && \
    /build/install-nami.sh
RUN bitnami-pkg install java-11.0.6-0 --checksum f7446f8bec72b6b2606d37ba917accc243e6cd4e722700c39ef83832c46fb0c6
RUN bitnami-pkg unpack tomcat-9.0.31-0 --checksum fc305adb108baf26ed6bab07d77d6245495837ac43d75c7e2c5bec76f3921cac
RUN bitnami-pkg unpack mysql-client-10.3.22-1 --checksum e9fa94f574c87d15f0b6aba7cff1c06f70c0e69c1c442378c9961fc148fa68ef
RUN bitnami-pkg unpack reportserverenterprise-3.1.1-6020-0 --checksum 6f0b221f72ebd61ce6268155ab7ca341c83d4157dae454591c0ca40f7aa7b4f7
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/install-gosu.sh
RUN /build/install-tini.sh

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="reportserverenterprise" \
    BITNAMI_IMAGE_VERSION="3.1.1-6020-debian-10-r16" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
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
