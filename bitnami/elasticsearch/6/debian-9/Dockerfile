FROM bitnami/minideb-extras-base:stretch-r358
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6 zlib1g
RUN . ./libcomponent.sh && component_unpack "java" "11.0.4-0" --checksum 43f132058f32891eaf2243a0484b6566dfeec2c2db4c5e10b036783083e8f039
RUN . ./libcomponent.sh && component_unpack "elasticsearch" "6.8.3-0" --checksum 21e082dbaf5b22723f62b4d51d737ac1b1a1c4e6f89154790e669630ae3801f3

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="elasticsearch" \
    BITNAMI_IMAGE_VERSION="6.8.3-debian-9-r6" \
    LD_LIBRARY_PATH="/opt/bitnami/elasticsearch/jdk/lib:/opt/bitnami/elasticsearch/jdk/lib/server:$LD_LIBRARY_PATH" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/elasticsearch/bin:$PATH"

EXPOSE 9200 9300

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
