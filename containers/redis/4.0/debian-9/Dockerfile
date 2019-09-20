FROM bitnami/minideb-extras-base:stretch-r366
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6
RUN . ./libcomponent.sh && component_unpack "redis" "4.0.14-2" --checksum f27538367d815dbd0949e9568b35e0ae7ff45b060f0910e2f5602f2b025cee1a

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="redis" \
    BITNAMI_IMAGE_VERSION="4.0.14-debian-9-r172" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/redis/bin:$PATH"

EXPOSE 6379

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
