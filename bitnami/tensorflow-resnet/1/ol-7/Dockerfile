FROM bitnami/oraclelinux-extras:7-r195
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages glibc libgcc libstdc++
RUN bitnami-pkg unpack tensorflow-resnet-1.12.0-20 --checksum d8e2a9fc0ba74e0bdc31020144f37b8deea2f37e449ed0ef128860d2490b1a7f

COPY rootfs /
ENV BITNAMI_APP_NAME="tensorflow-resnet" \
    BITNAMI_IMAGE_VERSION="1.12.0-ol-7-r13" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/tensorflow-resnet/bin:$PATH"

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "tail", "-f", "/dev/null" ]
