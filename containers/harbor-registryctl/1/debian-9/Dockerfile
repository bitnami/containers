FROM bitnami/minideb-extras-base:stretch-r365
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl libc6
RUN . ./libcomponent.sh && component_unpack "harbor-registryctl" "1.8.3-0" --checksum c797fadf8632fa1768355cc419a95c64d9a634e3e6af3d570a7d91645ee342e1
RUN . ./libcomponent.sh && component_unpack "harbor-registry" "1.8.3-0" --checksum 61048d47a06d73bc0bcf33c2f42f0b73685c160bd4d21dcdff046fc997d4665f

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="harbor-registryctl" \
    BITNAMI_IMAGE_VERSION="1.8.3-debian-9-r1" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/harbor-registryctl/bin:/opt/bitnami/harbor-registry/bin:$PATH"

VOLUME [ "/etc/registry", "/etc/registryctl", "/storage", "/var/lib/registry" ]

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
