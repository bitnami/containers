FROM bitnami/minideb-extras-base:stretch-r379
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libbz2-1.0 libc6 libgcc1 libjemalloc1 libncurses5 libreadline7 libsqlite3-0 libssl1.1 libtinfo5 zlib1g
RUN . ./libcomponent.sh && component_unpack "python" "2.7.17-0" --checksum 6a784d376685a94ea40a832eb94e0fac8b3d07487d4ea32f5207e0ff3657c94a
RUN . ./libcomponent.sh && component_unpack "java" "1.8.232-0" --checksum f4e5ff1d4fb13baf9bb2a4f2e5ffb328cf9eeb26d0b91214196e4473c2874adc
RUN . ./libcomponent.sh && component_unpack "cassandra" "3.11.5-0" --checksum d5eb10e00efad602ea3a8129dff9dac7ae82daebad8896914a3670050c1464f3

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="cassandra" \
    BITNAMI_IMAGE_VERSION="3.11.5-debian-9-r6" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/java/bin:/opt/bitnami/cassandra/bin:$PATH"

EXPOSE 9042 7000

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
