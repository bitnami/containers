FROM bitnami/minideb-extras-base:stretch-r363
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6
RUN . ./libcomponent.sh && component_unpack "harbor-core" "1.8.2-0" --checksum 4a374e58b3c39ace0ae582ccb850989bf0ba1f36e7cf3e24a52b51fc31982469

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="harbor-core" \
    BITNAMI_IMAGE_VERSION="1.8.2-debian-9-r35" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/harbor-core/bin:$PATH"

VOLUME [ "/etc/core", "/data" ]

EXPOSE 8080

WORKDIR /opt/bitnami/harbor-core
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "harbor_core" ]
