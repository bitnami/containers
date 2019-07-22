FROM bitnami/oraclelinux-extras-base:7-r355
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl
RUN . ./libcomponent.sh && component_unpack "harbor-registry" "1.8.2-rc1-0" --checksum edf52418526cd8ab8406d650fd79c710088d17796dd3e9f23d8f08e8cc1e366f

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="harbor-registry" \
    BITNAMI_IMAGE_VERSION="1.8.2-rc1-ol-7-r0" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/harbor-registry/bin:$PATH"

VOLUME [ "/etc/registry", "/storage", "/var/lib/registry" ]

EXPOSE 5000

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
