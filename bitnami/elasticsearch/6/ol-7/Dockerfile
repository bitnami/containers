FROM bitnami/oraclelinux-extras-base:7-r429
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages glibc hostname zlib
RUN . ./libcomponent.sh && component_unpack "java" "11.0.4-1" --checksum 17fdf204e88a92168b38d4f464876255fb6b651de8c889a4bb8340b39a860261
RUN . ./libcomponent.sh && component_unpack "elasticsearch" "6.8.3-1" --checksum 578f5c90ea6d022bd1e327609c3ebb534e89730b747f8046312cb7ec9563d321

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="elasticsearch" \
    BITNAMI_IMAGE_VERSION="6.8.3-ol-7-r22" \
    LD_LIBRARY_PATH="/opt/bitnami/elasticsearch/jdk/lib:/opt/bitnami/elasticsearch/jdk/lib/server:$LD_LIBRARY_PATH" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/elasticsearch/bin:$PATH"

EXPOSE 9200 9300

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
