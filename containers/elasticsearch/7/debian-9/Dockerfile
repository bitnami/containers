FROM bitnami/minideb-extras-base:stretch-r377
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libasound2-dev libc6 libfreetype6 libfreetype6-dev libgcc1 libx11-6 libxext6 libxi6 libxrender1 libxtst6 zlib1g
RUN . ./libcomponent.sh && component_unpack "java" "11.0.5-0" --checksum 9fc7502ca3c073e6ae7dd6cfa0c2da6b6c26caccbe41b6d7b5a9d26050ee54ff
RUN . ./libcomponent.sh && component_unpack "elasticsearch" "7.4.1-0" --checksum e929c0f43dd0647ad4880a582905e4273b264109433ba1dc43e3e12dbe178cbf

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="elasticsearch" \
    BITNAMI_IMAGE_VERSION="7.4.1-debian-9-r2" \
    LD_LIBRARY_PATH="/opt/bitnami/elasticsearch/jdk/lib:/opt/bitnami/elasticsearch/jdk/lib/server:$LD_LIBRARY_PATH" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/elasticsearch/bin:$PATH"

EXPOSE 9200 9300

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
