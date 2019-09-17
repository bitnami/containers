FROM bitnami/minideb-extras-base:stretch-r363
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN . ./libcomponent.sh && component_unpack "chartmuseum" "0.9.0-1" --checksum b00f680b3b1454e257fc23f52dcd4f7fc2a4a4bc02ba1f405812e282fbe954d6

COPY rootfs /
ENV BITNAMI_APP_NAME="chartmuseum" \
    BITNAMI_IMAGE_VERSION="0.9.0-debian-9-r43" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/chartmuseum/bin:$PATH"

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
