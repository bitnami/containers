FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl iproute2 ldap-utils libaio1 libaudit1 libc6 libcap-ng0 libgcc1 libjemalloc2 libncurses6 libnss-ldapd libpam-ldapd libpam0g libssl1.1 libstdc++6 libtinfo6 lsof nslcd procps rsync socat sudo unzip zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mariadb-galera" "10.1.44-2" --checksum 42422a4f0154593389aabb500a51009eb97311aace0c4ad73751ed7f04b01b13
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-0" --checksum 582d501eeb6b338a24f417fededbf14295903d6be55c52d66c52e616c81bcd8c
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN mkdir /docker-entrypoint-initdb.d

COPY rootfs /
RUN /opt/bitnami/scripts/mariadb-galera/postunpack.sh
ENV BITNAMI_APP_NAME="mariadb-galera" \
    BITNAMI_IMAGE_VERSION="10.1.44-debian-10-r100" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/mariadb/bin:/opt/bitnami/mariadb/sbin:/opt/bitnami/common/bin:$PATH"

EXPOSE 3306 4444 4567 4568

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/mariadb-galera/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/mariadb-galera/run.sh" ]
