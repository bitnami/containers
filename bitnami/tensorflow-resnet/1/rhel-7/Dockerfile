FROM registry.rhc4tp.openshift.com/bitnami/rhel-extras-7:latest
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages glibc libgcc libstdc++
RUN bitnami-pkg unpack tensorflow-resnet-1.13.0-0 --checksum ee1687d32c04c7f9881a03497009fc3f4c7af96422493ba0f068105ee226a886

COPY rootfs /
ENV BITNAMI_APP_NAME="tensorflow-resnet" \
    BITNAMI_IMAGE_VERSION="1.13.0-rhel-7-r24" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/tensorflow-resnet/bin:$PATH"

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "tail", "-f", "/dev/null" ]
