FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl iproute2 ldap-utils libaio1 libaudit1 libc6 libcap-ng0 libgcc1 libjemalloc2 libncurses6 libnss-ldapd libpam-ldapd libpam0g libssl1.1 libstdc++6 libtinfo6 lsof nslcd procps rsync socat sudo unzip zlib1g
RUN . ./libcomponent.sh && component_unpack "mariadb-galera" "10.3.21-0" --checksum 3389c8d8861b72cab0b98dc717cb5786bf05cbc9e75371cefc88f91f8d19fea9
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/install-gosu.sh
RUN mkdir /docker-entrypoint-initdb.d

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="mariadb-galera" \
    BITNAMI_IMAGE_VERSION="10.3.21-debian-10-r3" \
    PATH="/opt/bitnami/mariadb/bin:/opt/bitnami/mariadb/sbin:$PATH"

EXPOSE 3306 4444 4567 4568

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
