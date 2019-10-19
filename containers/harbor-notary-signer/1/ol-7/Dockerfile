FROM bitnami/oraclelinux-extras-base:7-r452
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages glibc
RUN . ./libcomponent.sh && component_unpack "harbor-notary-signer" "1.9.1-0" --checksum 07b403b84e58b3396bbc3fb257d3cb7b422f7dacd9a18344851d88f140e6d91f

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="harbor-notary-signer" \
    BITNAMI_IMAGE_VERSION="1.9.1-ol-7-r4" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/harbor-notary-signer/bin:$PATH" \
    SERVICE_NAME="notary_signer"

VOLUME [ "/etc/notary" ]

EXPOSE 7899

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
