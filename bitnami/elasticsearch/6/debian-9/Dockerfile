FROM bitnami/minideb-extras-base:stretch-r379
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6 zlib1g
RUN . ./libcomponent.sh && component_unpack "java" "11.0.5-0" --checksum 9fc7502ca3c073e6ae7dd6cfa0c2da6b6c26caccbe41b6d7b5a9d26050ee54ff
RUN . ./libcomponent.sh && component_unpack "elasticsearch" "6.8.5-0" --checksum aded68fb76d77775bbad27c065f35d32b8b72594bc8d520e2b2797ac5f352c95

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="elasticsearch" \
    BITNAMI_IMAGE_VERSION="6.8.5-debian-9-r0" \
    LD_LIBRARY_PATH="/opt/bitnami/elasticsearch/jdk/lib:/opt/bitnami/elasticsearch/jdk/lib/server:$LD_LIBRARY_PATH" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/elasticsearch/bin:$PATH"

EXPOSE 9200 9300

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
