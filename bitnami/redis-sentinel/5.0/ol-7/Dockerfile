FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl glibc gzip hostname libaio-devel procps-ng sudo tar which
RUN . ./libcomponent.sh && component_unpack "redis-sentinel" "5.0.6-0" --checksum 36e616a09e93b332ce327b6696f82cf30760f98ac200bc16b7ce9c4bf7c168a1

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="redis-sentinel" \
    BITNAMI_IMAGE_VERSION="5.0.6-ol-7-r7" \
    PATH="/opt/bitnami/redis-sentinel/bin:$PATH"

EXPOSE 26379

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
