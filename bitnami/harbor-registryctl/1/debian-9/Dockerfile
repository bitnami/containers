FROM bitnami/minideb-extras-base:stretch-r309
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl libc6
RUN . ./libcomponent.sh && component_unpack "harbor-registryctl" "1.8.2-rc1-0" --checksum c9e06e75bf73969c8b0ca14f2c3d16ea80bb6ba1b2e24d5f6c8223a128f3e040
RUN . ./libcomponent.sh && component_unpack "harbor-registry" "1.8.2-rc1-0" --checksum 1e58e82bb72e1ca2a6b912b1ed6f92a92fd68d5c61dcd6da0397880e939a6119

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="harbor-registryctl" \
    BITNAMI_IMAGE_VERSION="1.8.2-rc1-debian-9-r2" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/harbor-registryctl/bin:/opt/bitnami/harbor-registry/bin:$PATH"

VOLUME [ "/etc/registry", "/etc/registryctl", "/storage", "/var/lib/registry" ]

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
