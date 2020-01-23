FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libaio1 libaudit1 libc6 libcap-ng0 libgcc1 libjemalloc2 libncurses6 libpam0g libssl1.1 libstdc++6 libtinfo6 procps sudo unzip zlib1g
RUN . ./libcomponent.sh && component_unpack "mariadb" "10.3.21-0" --checksum fa4f936d6c6fe5c431e568124d5b738155466f3bbd4d0f2ffb2ea6aeb10fd37a
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/install-gosu.sh
RUN mkdir /docker-entrypoint-initdb.d

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="mariadb" \
    BITNAMI_IMAGE_VERSION="10.3.21-debian-10-r0" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/mariadb/bin:/opt/bitnami/mariadb/sbin:$PATH"

EXPOSE 3306

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
