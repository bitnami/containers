FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libaio1 libaudit1 libc6 libcap-ng0 libgcc1 libicu63 libjemalloc2 liblzma5 libncurses6 libpam0g libssl1.1 libstdc++6 libtinfo6 libxml2 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.312-0" --checksum a7e034898281dff05591e74de285ecd69899ddaaff4ce1ea9c09556ac89c9c72
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wildfly" "14.0.1-17" --checksum 97cb6c36c410a93901d68e875c8f1b78ed314a806ef58f7b2015600e45fe4cf6
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.3.32-0" --checksum 4a211faa9436c9747dfc4374cb9e8a7f9b0065dfc58dd4784cef0f5029c2e65e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ejbca" "7.4.3-2-0" --checksum e1870f19ea011428443d2a9a2d595fce7d5204c148635583724f4799cbdb5987
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/ejbca/postunpack.sh
RUN /opt/bitnami/scripts/java/postunpack.sh
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="ejbca" \
    BITNAMI_IMAGE_VERSION="7.4.3-2-debian-10-r89" \
    JAVA_HOME="/opt/bitnami/java" \
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
    PATH="/opt/bitnami/java/bin:/opt/bitnami/wildfly/bin:/opt/bitnami/mysql/bin:/opt/bitnami/common/bin:/opt/bitnami/ejbca/bin:$PATH"

EXPOSE 8080 9990

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/ejbca/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/ejbca/run.sh" ]
