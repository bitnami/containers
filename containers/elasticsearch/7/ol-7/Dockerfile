FROM bitnami/oraclelinux-extras-base:7-r427
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages alsa-lib-devel freetype-devel glibc hostname libX11-devel libXext-devel libXi-devel libXrender-devel libXtst-devel libgcc zlib
RUN . ./libcomponent.sh && component_unpack "java" "11.0.4-1" --checksum 17fdf204e88a92168b38d4f464876255fb6b651de8c889a4bb8340b39a860261
RUN . ./libcomponent.sh && component_unpack "elasticsearch" "7.3.2-1" --checksum ff5efa1862fec8f7c51f1310e45d70b2da7d62a12401c183e93d067ac4c22fac

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="elasticsearch" \
    BITNAMI_IMAGE_VERSION="7.3.2-ol-7-r12" \
    LD_LIBRARY_PATH="/opt/bitnami/elasticsearch/jdk/lib:/opt/bitnami/elasticsearch/jdk/lib/server:$LD_LIBRARY_PATH" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/elasticsearch/bin:$PATH"

EXPOSE 9200 9300

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
