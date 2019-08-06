FROM bitnami/oraclelinux-extras-base:7-r369
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages glibc
RUN . ./libcomponent.sh && component_unpack "harbor-notary-signer" "1.8.2-rc1-1" --checksum d00b495a5c714ef80ddfab6a72e39ee01e93b125b3fd2b8d65b11df60f4dc1f2

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="harbor-notary-signer" \
    BITNAMI_IMAGE_VERSION="1.8.2-rc1-ol-7-r16" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/harbor-notary-signer/bin:$PATH" \
    SERVICE_NAME="notary_signer"

VOLUME [ "/etc/notary" ]

EXPOSE 7899

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
