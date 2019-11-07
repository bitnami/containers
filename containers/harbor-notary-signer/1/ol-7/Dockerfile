FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl glibc gzip hostname libaio-devel procps-ng sudo tar which
RUN . ./libcomponent.sh && component_unpack "harbor-notary-signer" "1.9.2-0" --checksum 0ac172ce74448e616e3b91682de9ff2672628cb20357e70dcd1312b9bc29eb09

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="harbor-notary-signer" \
    BITNAMI_IMAGE_VERSION="1.9.2-ol-7-r3" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/harbor-notary-signer/bin:$PATH" \
    SERVICE_NAME="notary_signer"

VOLUME [ "/etc/notary" ]

EXPOSE 7899

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
