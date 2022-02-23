FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip iproute2 ldap-utils libaio1 libaudit1 libc6 libcap-ng0 libgcc1 libicu63 liblzma5 libncurses6 libnss-ldapd libpam-ldapd libpam0g libssl1.1 libstdc++6 libtinfo6 libxml2 nslcd procps psmisc rsync socat tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ini-file" "1.4.1-6" --checksum a947aad3f8cab0ff7c76506e1ea09156dfd442a6842500d1b8203f735b0e6b84
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mariadb-galera" "10.6.7-0" --checksum 762e09b5c6137bedd3e43e38d9566230f3e2e02b78c10df312598418be4f114a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-6" --checksum 6f8fd2267481ffbe899a7f93b7b3076cd78dd70b7b9835bed79414932a749664
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir /docker-entrypoint-initdb.d

COPY rootfs /
RUN /opt/bitnami/scripts/mariadb-galera/postunpack.sh
ENV BITNAMI_APP_NAME="mariadb-galera" \
    BITNAMI_IMAGE_VERSION="10.6.7-debian-10-r3" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/mariadb/bin:/opt/bitnami/mariadb/sbin:$PATH"

EXPOSE 3306 4444 4567 4568

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/mariadb-galera/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/mariadb-galera/run.sh" ]
