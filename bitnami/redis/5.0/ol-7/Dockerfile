FROM bitnami/oraclelinux-extras-base:7-r450
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages glibc
RUN . ./libcomponent.sh && component_unpack "redis" "5.0.5-3" --checksum 3a4d28845c64fd9a0f161b8e58544c47d0affffbbc1c193f867fc95e2f30c7cc

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="redis" \
    BITNAMI_IMAGE_VERSION="5.0.5-ol-7-r166" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/redis/bin:$PATH"

EXPOSE 6379

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
