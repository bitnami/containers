FROM bitnami/minideb-extras:stretch-r487
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages libc6 libgcc1 libstdc++6
RUN bitnami-pkg unpack tensorflow-resnet-1.14.0-1 --checksum e42b36801ad8963843842ece35818145fb94a558cc1e727478449821db4a1d67

COPY rootfs /
ENV BITNAMI_APP_NAME="tensorflow-resnet" \
    BITNAMI_IMAGE_VERSION="1.14.0-debian-9-r68" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/tensorflow-resnet/bin:$PATH"

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "tail", "-f", "/dev/null" ]
