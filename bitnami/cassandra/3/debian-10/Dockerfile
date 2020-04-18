FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libbz2-1.0 libc6 libgcc1 libjemalloc2 libncursesw6 libreadline7 libsqlite3-0 libssl1.1 libtinfo6 procps sudo unzip zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "2.7.17-3" --checksum a6269e56bb709da6d7c7145bd685b5ecc3056b5a38792c9dc3165785c41296e9
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.242-0" --checksum 3a70f3d1c3cd9bc6ec581b2a10373a2b323c0b9af40402ce8d19aeb0b3d02400
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "3.3.0-0" --checksum 44c8d8e59396bdec54adbffd26bd98f4a0198e6fc5a280953429d14cefed0868
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-0" --checksum 582d501eeb6b338a24f417fededbf14295903d6be55c52d66c52e616c81bcd8c
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "cassandra" "3.11.6-0" --checksum c2377a0eb6296a652fe276b2d0ae0dfec0187694d0bbf541c16320517d77d62c
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN ln -s /opt/bitnami/scripts/cassandra/entrypoint.sh /entrypoint.sh
RUN ln -s /opt/bitnami/scripts/cassandra/run.sh /run.sh

COPY rootfs /
RUN /opt/bitnami/scripts/cassandra/postunpack.sh
ENV BITNAMI_APP_NAME="cassandra" \
    BITNAMI_IMAGE_VERSION="3.11.6-debian-10-r66" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/java/bin:/opt/bitnami/common/bin:/opt/bitnami/common/bin:/opt/bitnami/cassandra/bin:$PATH"

EXPOSE 9042 7000

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/cassandra/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/cassandra/run.sh" ]
