FROM bitnami/minideb-extras-base:stretch-r376
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages iproute2 ldap-utils libaio1 libaudit1 libc6 libcap-ng0 libgcc1 libjemalloc1 libncurses5 libnss-ldapd libpam-ldapd libpam0g libssl1.0.2 libstdc++6 libtinfo5 lsof nslcd rsync socat zlib1g
RUN . ./libcomponent.sh && component_unpack "mariadb-galera" "10.3.18-4" --checksum 0299305ea3b7850569c54e2e7eda07c9e32f694679f1a45a1d2cba8217c7f0de
RUN mkdir /docker-entrypoint-initdb.d

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="mariadb-galera" \
    BITNAMI_IMAGE_VERSION="10.3.18-debian-9-r39" \
    PATH="/opt/bitnami/mariadb/bin:/opt/bitnami/mariadb/sbin:$PATH"

EXPOSE 3306 4444 4567 4568

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
