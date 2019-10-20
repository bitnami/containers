FROM bitnami/oraclelinux-extras-base:7-r453
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl glibc
RUN . ./libcomponent.sh && component_unpack "harbor-registryctl" "1.9.1-0" --checksum a9189c2a49874d90ab0e4e48ef293c57f544067ca9c29a6d457380429eb12340
RUN . ./libcomponent.sh && component_unpack "harbor-registry" "1.9.1-0" --checksum 2f4501ac8daea4f5e9141fbdad07eb1feec3f5b7779e1b0747a2870a1d531d81

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="harbor-registryctl" \
    BITNAMI_IMAGE_VERSION="1.9.1-ol-7-r5" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/harbor-registryctl/bin:/opt/bitnami/harbor-registry/bin:$PATH"

VOLUME [ "/etc/registry", "/etc/registryctl", "/storage", "/var/lib/registry" ]

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
