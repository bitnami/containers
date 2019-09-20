FROM bitnami/oraclelinux-extras-base:7-r423
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages alsa-lib-devel freetype-devel glibc hostname libX11-devel libXext-devel libXi-devel libXrender-devel libXtst-devel libgcc zlib
RUN . ./libcomponent.sh && component_unpack "java" "11.0.4-0" --checksum 3a17c3d9c943fc8342a9aa9786e924627d5b5579163e957d0ca1c9de523626f3
RUN . ./libcomponent.sh && component_unpack "elasticsearch" "7.3.2-0" --checksum b6566823a8fc474b5251a004fb584f87c34e5b93f1535933860629439723b386

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="elasticsearch" \
    BITNAMI_IMAGE_VERSION="7.3.2-ol-7-r7" \
    LD_LIBRARY_PATH="/opt/bitnami/elasticsearch/jdk/lib:/opt/bitnami/elasticsearch/jdk/lib/server:$LD_LIBRARY_PATH" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/elasticsearch/bin:$PATH"

EXPOSE 9200 9300

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
