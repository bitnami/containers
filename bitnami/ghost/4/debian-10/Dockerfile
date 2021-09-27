FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip jq libaudit1 libbz2-1.0 libc6 libcap-ng0 libffi6 libgcc1 libicu63 libjemalloc2 liblzma5 libncurses6 libncursesw6 libpam0g libreadline7 libsqlite3-0 libssl1.1 libstdc++6 libtinfo6 libxml2 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.12-2" --checksum e00677f5209d9426daff2db54cf00e04c46718bbdbc0717aee07e6a727ef05ad
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "14.17.6-0" --checksum 2c35e2baaa990e10d6cd5083530dbfa1f16075788eacbe4382d8b08abdbc8460
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.3.31-2" --checksum 15b394a022ca1d0b4b89bfee0487ee13f9e8cc697d0ca09ce62a0a3732536236
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ghost" "4.16.0-0" --checksum 0b4c7a98e1b5b16d31fce1a9445e11cf512948db3a404ed0cf1730e979001e4f
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/ghost/postunpack.sh
RUN /opt/bitnami/scripts/mysql-client/postunpack.sh
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="ghost" \
    BITNAMI_IMAGE_VERSION="4.16.0-debian-10-r2" \
    LD_PRELOAD="/opt/bitnami/common/lib/libnss_wrapper.so" \
    LNAME="ghost" \
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
    NSS_WRAPPER_GROUP="/opt/bitnami/ghost/nss-wrapper/nss_group" \
    NSS_WRAPPER_PASSWD="/opt/bitnami/ghost/nss-wrapper/nss_passwd" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/node/bin:/opt/bitnami/mysql/bin:/opt/bitnami/common/bin:/opt/bitnami/ghost/bin:$PATH"

EXPOSE 2368 3000

WORKDIR /opt/bitnami/ghost
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/ghost/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/ghost/run.sh" ]
