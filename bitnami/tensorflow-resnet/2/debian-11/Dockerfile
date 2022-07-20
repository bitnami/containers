FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gcc-10 gzip libc6 libgcc-s1 libstdc++6 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "tensorflow-resnet" "2.9.1-1" --checksum cf6b050407ae3a77bcfa6fc92347878243d8109ffb48969212b737e7a1a015b0
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-152" --checksum 0c751c7e2ec0bc900a19dbec0306d6294fe744ddfb0fa64197ba1a36040092f0
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
ENV APP_VERSION="2.9.1" \
    BITNAMI_APP_NAME="tensorflow-resnet" \
    PATH="/opt/bitnami/tensorflow-resnet/bin:/opt/bitnami/common/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/tensorflow-resnet/entrypoint.sh" ]
CMD [ "tail", "-f", "/dev/null" ]
