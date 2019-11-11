FROM bitnami/minideb-extras-base:stretch-r379
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl libc6
RUN . ./libcomponent.sh && component_unpack "harbor-registryctl" "1.9.2-0" --checksum 6f6314cd761a17101a2209ff250304fba9c7f70b97dafe577e036f2d6e771f34
RUN . ./libcomponent.sh && component_unpack "harbor-registry" "1.9.2-0" --checksum 497451b2917e9bf17ca90eadf34d7aab634a85924fdadb4cebd9e2f2a8092a1d

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="harbor-registryctl" \
    BITNAMI_IMAGE_VERSION="1.9.2-debian-9-r5" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/harbor-registryctl/bin:/opt/bitnami/harbor-registry/bin:$PATH"

VOLUME [ "/etc/registry", "/etc/registryctl", "/storage", "/var/lib/registry" ]

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
