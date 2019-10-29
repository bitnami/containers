FROM bitnami/oraclelinux-extras-base:7-r463
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages alsa-lib-devel freetype-devel glibc hostname libX11-devel libXext-devel libXi-devel libXrender-devel libXtst-devel libgcc zlib
RUN . ./libcomponent.sh && component_unpack "java" "11.0.5-0" --checksum e45456416649c404add4f02355d6efe6c82f960153a9807e4ba9fea16d28a237
RUN . ./libcomponent.sh && component_unpack "elasticsearch" "7.4.1-0" --checksum bc51b0b83692099eae14f3e51f24165c0299c406a7018419dbfa0b7047547e4f

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="elasticsearch" \
    BITNAMI_IMAGE_VERSION="7.4.1-ol-7-r6" \
    LD_LIBRARY_PATH="/opt/bitnami/elasticsearch/jdk/lib:/opt/bitnami/elasticsearch/jdk/lib/server:$LD_LIBRARY_PATH" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/elasticsearch/bin:$PATH"

EXPOSE 9200 9300

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
