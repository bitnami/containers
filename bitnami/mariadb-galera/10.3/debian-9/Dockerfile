FROM bitnami/minideb-extras-base:stretch-r366
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages iproute2 ldap-utils libaio1 libaudit1 libc6 libcap-ng0 libgcc1 libjemalloc1 libncurses5 libnss-ldapd libpam-ldapd libpam0g libssl1.0.2 libstdc++6 libtinfo5 lsof nslcd rsync socat zlib1g
RUN . ./libcomponent.sh && component_unpack "mariadb-galera" "10.3.18-1" --checksum 15d392bf6235d844d85d54a95996082904a218d5ec432bf74a088cbcfbdfea65
RUN mkdir /docker-entrypoint-initdb.d

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="mariadb-galera" \
    BITNAMI_IMAGE_VERSION="10.3.18-debian-9-r9" \
    PATH="/opt/bitnami/mariadb/bin:/opt/bitnami/mariadb/sbin:$PATH"

EXPOSE 3306 4444 4567 4568

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
