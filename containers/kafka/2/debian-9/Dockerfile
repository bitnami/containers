FROM bitnami/minideb-extras-base:stretch-r370
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6 libgcc1 zlib1g
RUN . ./libcomponent.sh && component_unpack "java" "1.8.222-1" --checksum 373c9f3d2943b9ff653fc0e7c69b1d54a75807726691a09190648808500b8253
RUN . ./libcomponent.sh && component_unpack "kafka" "2.3.0-1" --checksum 4a125a6a78a7dd68e47bff901135943174cf322d6c5cbfdd6be63441dfac3935

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="kafka" \
    BITNAMI_IMAGE_VERSION="2.3.0-debian-9-r91" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/kafka/bin:$PATH"

EXPOSE 9092

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
