FROM bitnami/minideb-extras-base:stretch-r376
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6
RUN . ./libcomponent.sh && component_unpack "harbor-notary-server" "1.9.1-0" --checksum d09b165c3be5c1a8a803f406398f06c33a523f0856210dcbe9d00a1a7ca83ea1

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="harbor-notary-server" \
    BITNAMI_IMAGE_VERSION="1.9.1-debian-9-r1" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/harbor-notary-server/bin:$PATH" \
    SERVICE_NAME="notary_server"

VOLUME [ "/etc/notary" ]

EXPOSE 4443

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
