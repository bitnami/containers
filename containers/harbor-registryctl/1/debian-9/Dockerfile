FROM bitnami/minideb-extras-base:stretch-r379
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl libc6
RUN . ./libcomponent.sh && component_unpack "harbor-registryctl" "1.9.3-0" --checksum f5e443b9c79d947adc68fccf118876b9d890b9496513dda10485e901df01571e
RUN . ./libcomponent.sh && component_unpack "harbor-registry" "1.9.3-0" --checksum 53e99d07aa4063e9ca91e383ff6c8513b74d4ae268fec1ea2d195093afbc7c31

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="harbor-registryctl" \
    BITNAMI_IMAGE_VERSION="1.9.3-debian-9-r1" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/harbor-registryctl/bin:/opt/bitnami/harbor-registry/bin:$PATH"

VOLUME [ "/etc/registry", "/etc/registryctl", "/storage", "/var/lib/registry" ]

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
