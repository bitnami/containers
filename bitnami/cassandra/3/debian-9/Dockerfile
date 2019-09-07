FROM bitnami/minideb-extras-base:stretch-r355
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libbz2-1.0 libc6 libgcc1 libjemalloc1 libncurses5 libreadline7 libsqlite3-0 libssl1.1 libtinfo5 zlib1g
RUN . ./libcomponent.sh && component_unpack "python" "2.7.16-0" --checksum 1bd6ac396615c99f639a1b4755425accd03e0ec500e52bf068491cc0cac6d385
RUN . ./libcomponent.sh && component_unpack "java" "1.8.222-0" --checksum e5a677e160c01cd605bc6aae75cc937d4b2d37514b3e1d0a1dd2d332422e68c7
RUN . ./libcomponent.sh && component_unpack "cassandra" "3.11.4-3" --checksum 68369ea1592bbe52edf4abb4475e1b54235b0df4a15e91d844e6159367770606

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="cassandra" \
    BITNAMI_IMAGE_VERSION="3.11.4-debian-9-r189" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/java/bin:/opt/bitnami/cassandra/bin:$PATH"

EXPOSE 9042 7000

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
