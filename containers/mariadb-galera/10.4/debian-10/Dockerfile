FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip iproute2 ldap-utils libaio1 libaudit1 libc6 libcap-ng0 libgcc1 libicu63 libjemalloc2 liblzma5 libncurses6 libnss-ldapd libpam-ldapd libpam0g libssl1.1 libstdc++6 libtinfo6 libxml2 lsof nslcd procps psmisc rsync socat tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ini-file" "1.4.1-2" --checksum 8fc4b049c856c022b49dd27ded8d0f3945a01f1fa8d2196f391ce481b8e95e3a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mariadb-galera" "10.4.22-0" --checksum eea454c88cbc678a01aba154b2574fd404aca2129e9f1f9571e31253391ece88
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-2" --checksum 7419bc5e2be68eb14c92e321acc843413481cda73323fb8c0d1dda8b1e5aa9d5
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir /docker-entrypoint-initdb.d

COPY rootfs /
RUN /opt/bitnami/scripts/mariadb-galera/postunpack.sh
ENV BITNAMI_APP_NAME="mariadb-galera" \
    BITNAMI_IMAGE_VERSION="10.4.22-debian-10-r64" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/mariadb/bin:/opt/bitnami/mariadb/sbin:$PATH"

EXPOSE 3306 4444 4567 4568

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/mariadb-galera/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/mariadb-galera/run.sh" ]
