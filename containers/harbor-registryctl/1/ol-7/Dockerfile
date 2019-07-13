FROM bitnami/oraclelinux-extras-base:7-r346
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl glibc
RUN . ./libcomponent.sh && component_unpack "harbor-registryctl" "1.8.1-0" --checksum ac9220725f31b166e58216d6c450c8c003afbd452895256758419b2f73ab4858
RUN . ./libcomponent.sh && component_unpack "harbor-registry" "1.8.1-0" --checksum 0d7edcd9013cc2d0689488dd9e310b508285a0b975abb0ad3d94db3750587eb1

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="harbor-registryctl" \
    BITNAMI_IMAGE_VERSION="1.8.1-ol-7-r11" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/harbor-registryctl/bin:/opt/bitnami/harbor-registry/bin:$PATH"

VOLUME [ "/etc/registry", "/etc/registryctl", "/storage", "/var/lib/registry" ]

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
