FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl glibc gzip hostname libaio-devel procps-ng sudo tar which
RUN . ./libcomponent.sh && component_unpack "harbor-registryctl" "1.9.3-0" --checksum e2ae46ced88d3e7f87746f6c27eb5b61cfa524fac1aeaa705ce72d052e1801ba
RUN . ./libcomponent.sh && component_unpack "harbor-registry" "1.9.3-0" --checksum 26e11a24bda4f6ae39b3052bd1df95304e34e7f02b962e449388cf975c1bd838

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="harbor-registryctl" \
    BITNAMI_IMAGE_VERSION="1.9.3-ol-7-r2" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/harbor-registryctl/bin:/opt/bitnami/harbor-registry/bin:$PATH"

VOLUME [ "/etc/registry", "/etc/registryctl", "/storage", "/var/lib/registry" ]

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
