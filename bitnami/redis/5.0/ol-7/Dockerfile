FROM bitnami/oraclelinux-extras-base:7-r436
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages glibc
RUN . ./libcomponent.sh && component_unpack "redis" "5.0.5-2" --checksum 74280aa2ec7497be5cc71d64cbd2d8ca025d6638cc8b5502ba06262f60cf7fd6

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="redis" \
    BITNAMI_IMAGE_VERSION="5.0.5-ol-7-r152" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/redis/bin:$PATH"

EXPOSE 6379

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
