FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip iproute2 ldap-utils libaio1 libaudit1 libc6 libcap-ng0 libgcc1 libicu63 libjemalloc2 liblzma5 libncurses6 libnss-ldapd libpam-ldapd libpam0g libssl1.1 libstdc++6 libtinfo6 libxml2 lsof nslcd procps rsync socat tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ini-file" "1.3.0-0" --checksum 41c77c119c1fb01936942bdd7f463f777d5edc29809038f977a7ab78ffdab342
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mariadb-galera" "10.1.45-4" --checksum f98bd57693f85508747a48f4480b11b36829025ec0d417350005a24c8306f485
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-0" --checksum 582d501eeb6b338a24f417fededbf14295903d6be55c52d66c52e616c81bcd8c
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN mkdir /docker-entrypoint-initdb.d

COPY rootfs /
RUN /opt/bitnami/scripts/mariadb-galera/postunpack.sh
ENV BITNAMI_APP_NAME="mariadb-galera" \
    BITNAMI_IMAGE_VERSION="10.1.45-debian-10-r43" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/mariadb/bin:/opt/bitnami/mariadb/sbin:$PATH"

EXPOSE 3306 4444 4567 4568

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/mariadb-galera/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/mariadb-galera/run.sh" ]
