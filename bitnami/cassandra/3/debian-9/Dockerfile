FROM bitnami/minideb-extras-base:stretch-r372
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libbz2-1.0 libc6 libgcc1 libjemalloc1 libncurses5 libreadline7 libsqlite3-0 libssl1.1 libtinfo5 zlib1g
RUN . ./libcomponent.sh && component_unpack "python" "2.7.16-1" --checksum 543c1ef96abbde2912ea661b76de9392b97d90d7ec12ed1027477eb730befabd
RUN . ./libcomponent.sh && component_unpack "java" "1.8.222-1" --checksum 373c9f3d2943b9ff653fc0e7c69b1d54a75807726691a09190648808500b8253
RUN . ./libcomponent.sh && component_unpack "cassandra" "3.11.4-4" --checksum e2a2689ee8648deac35152951be7b0f591a1da3979c6ed7c6bc8aa4dcc11bfcb

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="cassandra" \
    BITNAMI_IMAGE_VERSION="3.11.4-debian-9-r206" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/java/bin:/opt/bitnami/cassandra/bin:$PATH"

EXPOSE 9042 7000

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
