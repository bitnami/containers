FROM bitnami/minideb-extras-base:stretch-r363
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6
RUN . ./libcomponent.sh && component_unpack "harbor-notary-server" "1.8.3-0" --checksum cb43d9a6b0070929fd61adfc28f2c35314a7516b830ac69b64b569513fb10030

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="harbor-notary-server" \
    BITNAMI_IMAGE_VERSION="1.8.3-debian-9-r0" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/harbor-notary-server/bin:$PATH" \
    SERVICE_NAME="notary_server"

VOLUME [ "/etc/notary" ]

EXPOSE 4443

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
