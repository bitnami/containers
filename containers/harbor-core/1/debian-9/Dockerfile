FROM bitnami/minideb-extras-base:stretch-r366
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6
RUN . ./libcomponent.sh && component_unpack "harbor-core" "1.9.0-0" --checksum 41408e46e27d7695b6ecbd2768520e5a1999ddcb275a79b195122081cfbf852d

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="harbor-core" \
    BITNAMI_IMAGE_VERSION="1.9.0-debian-9-r1" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/harbor-core/bin:$PATH"

VOLUME [ "/etc/core", "/data" ]

EXPOSE 8080

WORKDIR /opt/bitnami/harbor-core
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "harbor_core" ]
