FROM bitnami/minideb-extras:stretch-r222
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages libc6 libgcc1 libstdc++6
RUN bitnami-pkg unpack tensorflow-resnet-1.12.0-20 --checksum f36a880fe39e19cf1a1d1f77f1ee3249b7b0b051601bed48a12398ff3de74c46

COPY rootfs /
ENV BITNAMI_APP_NAME="tensorflow-resnet" \
    BITNAMI_IMAGE_VERSION="1.12.0-debian-9-r14" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/tensorflow-resnet/bin:$PATH"

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "tail", "-f", "/dev/null" ]
