FROM bitnami/minideb-extras-base:stretch-r323
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN . ./libcomponent.sh && component_unpack "chartmuseum" "0.9.0-0" --checksum 909e1162d83098ea680653e9cd43d71ebab0303fc5f333eb89345d43e928772a

COPY rootfs /
ENV BITNAMI_APP_NAME="chartmuseum" \
    BITNAMI_IMAGE_VERSION="0.9.0-debian-9-r0" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/chartmuseum/bin:$PATH"

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
