FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV PATH="/opt/bitnami/java/bin:/opt/bitnami/tomcat/bin:/opt/bitnami/mysql/bin:/opt/bitnami/common/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl fontconfig fonts-dejavu-extra gzip libaudit1 libc6 libcap-ng0 libgcc1 libicu63 libjemalloc2 liblzma5 libncurses6 libpam0g libssl1.1 libstdc++6 libtinfo6 libxml2 procps sudo tar zlib1g
RUN /build/bitnami-user.sh
RUN /build/install-nami.sh
RUN bitnami-pkg install java-11.0.7-1 --checksum e01669f15e2e655613c19eab1b8b533a720d6334766da34190a2a4939f5a0bc8
RUN bitnami-pkg unpack tomcat-9.0.36-1 --checksum e3ef8a7dc9785263e36abafce42498db7f8c236d6f441209bb990ba5f1dd0459
RUN bitnami-pkg unpack mysql-client-10.3.23-0 --checksum 7af3cead7a38670bed924fbc99e20c67f6244bb5a92642adb4ab6cd307aa9a5e
RUN bitnami-pkg install tini-0.19.0-0 --checksum 9a8ae20be31a518f042fcec359f2cf35bfdb4e2a56f2fa8ff9ef2ecaf45da80c
RUN bitnami-pkg unpack reportserver-3.1.2-6022-2 --checksum ce9e04548cbf5bf33043c800bed25fd574e91c88733b1bfe2e9ac64230c3f390
RUN bitnami-pkg install gosu-1.12.0-0 --checksum 582d501eeb6b338a24f417fededbf14295903d6be55c52d66c52e616c81bcd8c
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="reportserver" \
    BITNAMI_IMAGE_VERSION="3.1.2-6022-debian-10-r85" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    MYSQL_CLIENT_ENABLE_SSL="no" \
    MYSQL_CLIENT_SSL_CA_FILE="" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux" \
    REPORTSERVER_CRYPTPASSPHRASE="" \
    REPORTSERVER_CRYPTSALT="" \
    REPORTSERVER_DATABASE_NAME="bitnami_reportserver" \
    REPORTSERVER_DATABASE_PASSWORD="" \
    REPORTSERVER_DATABASE_USER="bn_reportserver" \
    REPORTSERVER_EMAIL="user@example.com" \
    REPORTSERVER_INSTALLDEMODATA="" \
    REPORTSERVER_JAVA_OPTS="-Djava.awt.headless=true -Xmx4g -XX:+UseConcMarkSweepGC -XX:MaxPermSize=512M -Dfile.encoding=UTF8" \
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
