FROM bitnami/minideb-extras-base:stretch-r365
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl
RUN . ./libcomponent.sh && component_unpack "harbor-registry" "1.9.0-0" --checksum 2bc33d34c3b2f81c11d016ac04a64fe1696fd3de209d68711d2e1aa0d654ca94

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="harbor-registry" \
    BITNAMI_IMAGE_VERSION="1.9.0-debian-9-r0" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/harbor-registry/bin:$PATH"

VOLUME [ "/etc/registry", "/storage", "/var/lib/registry" ]

EXPOSE 5000

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
