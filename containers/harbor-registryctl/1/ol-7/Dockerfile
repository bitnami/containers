FROM bitnami/oraclelinux-extras-base:7-r378
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl glibc
RUN . ./libcomponent.sh && component_unpack "harbor-registryctl" "1.8.1-0" --checksum 5f8d842eb229bd6a9d94a2e09644a357a409c1f8301501704a96f45e6104f9a5
RUN . ./libcomponent.sh && component_unpack "harbor-registry" "1.8.1-0" --checksum 23146d76a17d9a92b3ec89f6ab1e35fb6b062b1693a24faa56ccf39c4dfe219f

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="harbor-registryctl" \
    BITNAMI_IMAGE_VERSION="1.8.1-ol-7-r22" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/harbor-registryctl/bin:/opt/bitnami/harbor-registry/bin:$PATH"

VOLUME [ "/etc/registry", "/etc/registryctl", "/storage", "/var/lib/registry" ]

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
