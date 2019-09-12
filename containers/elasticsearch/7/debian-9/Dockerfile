FROM bitnami/minideb-extras-base:stretch-r360
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libasound2-dev libc6 libfreetype6 libfreetype6-dev libgcc1 libx11-6 libxext6 libxi6 libxrender1 libxtst6 zlib1g
RUN . ./libcomponent.sh && component_unpack "java" "11.0.4-0" --checksum 43f132058f32891eaf2243a0484b6566dfeec2c2db4c5e10b036783083e8f039
RUN . ./libcomponent.sh && component_unpack "elasticsearch" "7.3.2-0" --checksum ae3375a67cc91dd55ffaa4faaf336dec9cfa2824e62c88266a36928f0bd81511

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="elasticsearch" \
    BITNAMI_IMAGE_VERSION="7.3.2-debian-9-r0" \
    LD_LIBRARY_PATH="/opt/bitnami/elasticsearch/jdk/lib:/opt/bitnami/elasticsearch/jdk/lib/server:$LD_LIBRARY_PATH" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/elasticsearch/bin:$PATH"

EXPOSE 9200 9300

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
