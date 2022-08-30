FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="10.7.5-debian-11-r4" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/mariadb" \
      org.opencontainers.image.title="mariadb" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="10.7.5"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libaio1 libaudit1 libc6 libcap-ng0 libcrypt1 libgcc-s1 libicu67 liblzma5 libncurses6 libpam0g libssl1.1 libstdc++6 libtinfo6 libxml2 procps psmisc tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ini-file" "1.4.3-153" --checksum 4692a063a41c8382fbf1629f92bb91cc3064d50b25bddeb7e1b299c749e39afd
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mariadb" "10.7.5-1" --checksum 12916c81cc276b6a4fd10d600cf4c94897df686b02f11fd485ce917d6848e847
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-154" --checksum e36c3d90f4fbfbe989f40947fa7c8ab817f12fcf97d3aef893c753a20ce976ab
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir /docker-entrypoint-initdb.d

COPY rootfs /
RUN /opt/bitnami/scripts/mariadb/postunpack.sh
ENV APP_VERSION="10.7.5" \
    BITNAMI_APP_NAME="mariadb" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/mariadb/bin:/opt/bitnami/mariadb/sbin:$PATH"

EXPOSE 3306

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/mariadb/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/mariadb/run.sh" ]
