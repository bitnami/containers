FROM bitnami/oraclelinux-extras-base:7-r422
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl glibc
RUN . ./libcomponent.sh && component_unpack "harbor-registryctl" "1.9.0-0" --checksum aed2984289680d5bee85b851b94bcd17989cdc1735fde20b61e898fb083187b9
RUN . ./libcomponent.sh && component_unpack "harbor-registry" "1.9.0-0" --checksum 40879a55a23a3c606bdd314a17529cdb91461f4f0db0878753cd5df0103b8753

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="harbor-registryctl" \
    BITNAMI_IMAGE_VERSION="1.9.0-ol-7-r0" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/harbor-registryctl/bin:/opt/bitnami/harbor-registry/bin:$PATH"

VOLUME [ "/etc/registry", "/etc/registryctl", "/storage", "/var/lib/registry" ]

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
