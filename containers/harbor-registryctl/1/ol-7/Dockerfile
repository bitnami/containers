FROM bitnami/oraclelinux-extras-base:7-r358
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl glibc
RUN . ./libcomponent.sh && component_unpack "harbor-registryctl" "1.8.2-rc1-0" --checksum 1f72ce2af73a905ae5d205ecf5b82c88c1a23196becc222e505d51db1b3b65c6
RUN . ./libcomponent.sh && component_unpack "harbor-registry" "1.8.2-rc1-0" --checksum edf52418526cd8ab8406d650fd79c710088d17796dd3e9f23d8f08e8cc1e366f

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="harbor-registryctl" \
    BITNAMI_IMAGE_VERSION="1.8.2-rc1-ol-7-r3" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/harbor-registryctl/bin:/opt/bitnami/harbor-registry/bin:$PATH"

VOLUME [ "/etc/registry", "/etc/registryctl", "/storage", "/var/lib/registry" ]

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
