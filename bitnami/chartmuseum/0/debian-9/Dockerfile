FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl procps unzip
RUN . ./libcomponent.sh && component_unpack "chartmuseum" "0.10.0-0" --checksum 2bb2d2de38cee4213c4e84df42b4b4f8397091ee67b818b468dc7639db8ca44a

COPY rootfs /
ENV BITNAMI_APP_NAME="chartmuseum" \
    BITNAMI_IMAGE_VERSION="0.10.0-debian-9-r0" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/chartmuseum/bin:$PATH"

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
