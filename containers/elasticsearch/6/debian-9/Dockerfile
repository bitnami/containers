FROM bitnami/minideb-extras-base:stretch-r352
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6 zlib1g
RUN . ./libcomponent.sh && component_unpack "java" "11.0.4-0" --checksum 43f132058f32891eaf2243a0484b6566dfeec2c2db4c5e10b036783083e8f039
RUN . ./libcomponent.sh && component_unpack "elasticsearch" "6.8.2-0" --checksum 6222ce47e77c22c9bb418c05f58bdaed65d1599036531233386a9b43abca5d37

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="elasticsearch" \
    BITNAMI_IMAGE_VERSION="6.8.2-debian-9-r38" \
    LD_LIBRARY_PATH="/opt/bitnami/elasticsearch/jdk/lib:/opt/bitnami/elasticsearch/jdk/lib/server:$LD_LIBRARY_PATH" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/elasticsearch/bin:$PATH"

EXPOSE 9200 9300

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
