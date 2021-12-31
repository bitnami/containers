FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gcc-7 gzip libc6 libgcc1 libstdc++6 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "tensorflow-resnet" "2.6.1-0" --checksum a1aecc2d09b8bd9d00add4314c5eba8e92434fc50af5c7c642168e2277e7f8d8
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
ENV BITNAMI_APP_NAME="tensorflow-resnet" \
    BITNAMI_IMAGE_VERSION="2.6.1-debian-10-r48" \
    PATH="/opt/bitnami/tensorflow-resnet/bin:/opt/bitnami/common/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/tensorflow-resnet/entrypoint.sh" ]
CMD [ "tail", "-f", "/dev/null" ]
