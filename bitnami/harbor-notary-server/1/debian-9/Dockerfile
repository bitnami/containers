FROM bitnami/minideb-extras-base:stretch-r366
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6
RUN . ./libcomponent.sh && component_unpack "harbor-notary-server" "1.9.0-0" --checksum cd04e663e0a5102a3b20e9c55bf1b79d1f904104f154518cc5d78c83f5299928

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="harbor-notary-server" \
    BITNAMI_IMAGE_VERSION="1.9.0-debian-9-r1" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/harbor-notary-server/bin:$PATH" \
    SERVICE_NAME="notary_server"

VOLUME [ "/etc/notary" ]

EXPOSE 4443

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
