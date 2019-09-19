FROM bitnami/oraclelinux-extras-base:7-r422
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl
RUN . ./libcomponent.sh && component_unpack "harbor-registry" "1.8.3-0" --checksum 802d622eebcabbb3af185943d12bfe0a03fc4f821265b090a553a249f79bb125

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="harbor-registry" \
    BITNAMI_IMAGE_VERSION="1.8.3-ol-7-r1" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/harbor-registry/bin:$PATH"

VOLUME [ "/etc/registry", "/storage", "/var/lib/registry" ]

EXPOSE 5000

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
