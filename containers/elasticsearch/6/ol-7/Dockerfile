FROM bitnami/oraclelinux-extras-base:7-r405
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages glibc hostname zlib
RUN . ./libcomponent.sh && component_unpack "java" "11.0.4-0" --checksum 3a17c3d9c943fc8342a9aa9786e924627d5b5579163e957d0ca1c9de523626f3
RUN . ./libcomponent.sh && component_unpack "elasticsearch" "6.8.3-0" --checksum 9be8b07502480308e0229e6120e25fe92cffae7d95ef2288c577d57a2e8def31

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="elasticsearch" \
    BITNAMI_IMAGE_VERSION="6.8.3-ol-7-r0" \
    LD_LIBRARY_PATH="/opt/bitnami/elasticsearch/jdk/lib:/opt/bitnami/elasticsearch/jdk/lib/server:$LD_LIBRARY_PATH" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/elasticsearch/bin:$PATH"

EXPOSE 9200 9300

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
