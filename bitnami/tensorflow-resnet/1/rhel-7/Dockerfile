FROM registry.rhc4tp.openshift.com/bitnami/rhel-extras-7:latest
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages glibc libgcc libstdc++
RUN bitnami-pkg unpack tensorflow-resnet-1.12.0-22 --checksum 91ad259abb62246ae338423fa0cfa3397f384a6af3271055e235116004c56d34

COPY rootfs /
ENV BITNAMI_APP_NAME="tensorflow-resnet" \
    BITNAMI_IMAGE_VERSION="1.12.0-rhel-7-r18" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/tensorflow-resnet/bin:$PATH"

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "tail", "-f", "/dev/null" ]
