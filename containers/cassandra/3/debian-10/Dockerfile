FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libbz2-1.0 libc6 libgcc1 libjemalloc2 libncursesw6 libreadline7 libsqlite3-0 libssl1.1 libtinfo6 procps sudo unzip zlib1g
RUN . ./libcomponent.sh && component_unpack "python" "2.7.17-2" --checksum bbb96813350b14cee93671e66b49db1031c11a0c20b70867a96ff9b9b522d8ec
RUN . ./libcomponent.sh && component_unpack "java" "1.8.242-0" --checksum 3a70f3d1c3cd9bc6ec581b2a10373a2b323c0b9af40402ce8d19aeb0b3d02400
RUN . ./libcomponent.sh && component_unpack "yq" "3.2.0-0" --checksum c1bed30835eb05a04c9705ad17a0763f3e7dc4558bb878611e00e4ee8e2e1ac7
RUN . ./libcomponent.sh && component_unpack "cassandra" "3.11.6-0" --checksum c2377a0eb6296a652fe276b2d0ae0dfec0187694d0bbf541c16320517d77d62c
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/install-gosu.sh

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="cassandra" \
    BITNAMI_IMAGE_VERSION="3.11.6-debian-10-r14" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/java/bin:/opt/bitnami/common/bin:/opt/bitnami/cassandra/bin:$PATH"

EXPOSE 9042 7000

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
