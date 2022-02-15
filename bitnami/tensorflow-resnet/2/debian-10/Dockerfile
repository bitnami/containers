FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gcc-7 gzip libc6 libgcc1 libstdc++6 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "tensorflow-resnet" "2.8.0-30" --checksum f38075c112b1e02d86a1d68d20cfe059edfb61bda0d96d2466e38399c95645ae
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-4" --checksum ec62006ece7e0b49c65926e458ba2b71d6d251552118b1378840b1803dbb3d53
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
ENV BITNAMI_APP_NAME="tensorflow-resnet" \
    BITNAMI_IMAGE_VERSION="2.8.0-debian-10-r0" \
    PATH="/opt/bitnami/tensorflow-resnet/bin:/opt/bitnami/common/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/tensorflow-resnet/entrypoint.sh" ]
CMD [ "tail", "-f", "/dev/null" ]
